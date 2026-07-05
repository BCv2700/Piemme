from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date as date_type
import os
import requests

from app.database import get_db
from app.models.article_achat import ArticleAchat
from app.schemas.article_achat import ArticleAchatOut, ArticleAchatCreate, ArticleAchatUpdate
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/articles-achat", tags=["ArticlesAchat"])


@router.get("/", response_model=list[ArticleAchatOut])
def list_articles_achat(db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    return db.query(ArticleAchat).order_by(ArticleAchat.nom).all()


@router.post("/", response_model=ArticleAchatOut)
def create_article_achat(article: ArticleAchatCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_article = ArticleAchat(**article.dict())
    db.add(db_article)
    db.commit()
    db.refresh(db_article)
    return db_article


@router.patch("/{article_id}", response_model=ArticleAchatOut)
def update_article_achat(article_id: int, article: ArticleAchatUpdate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_article = db.query(ArticleAchat).filter(ArticleAchat.id == article_id).first()
    if not db_article:
        raise HTTPException(status_code=404, detail="Article introuvable")
    for key, value in article.dict(exclude_unset=True).items():
        setattr(db_article, key, value)
    db.commit()
    db.refresh(db_article)
    return db_article


@router.delete("/{article_id}")
def delete_article_achat(article_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_article = db.query(ArticleAchat).filter(ArticleAchat.id == article_id).first()
    if not db_article:
        raise HTTPException(status_code=404, detail="Article introuvable")
    db.delete(db_article)
    db.commit()
    return {"message": "Article supprimé"}


@router.post("/decocher-tout")
def decocher_tout(db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Décoche a_commander pour tous les articles en une seule requête SQL (UPDATE
    en masse), au lieu d'une requête par article. Beaucoup plus rapide côté
    interface, et évite de multiplier les connexions à la base pour rien.
    """
    nb = (
        db.query(ArticleAchat)
        .filter(ArticleAchat.a_commander == True)  # noqa: E712
        .update({ArticleAchat.a_commander: False})
    )
    db.commit()
    return {"message": str(nb) + " article(s) décoché(s)", "nb": nb}


@router.post("/envoyer-commande")
def envoyer_commande(db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Envoie par email la liste des articles cochés "à commander" (a_commander=True),
    groupée par fournisseur. Envoi via l'API Resend (HTTPS, ne dépend pas du SMTP,
    qui est bloqué par Railway sur les plans Free/Hobby). Variables d'environnement
    nécessaires : RESEND_API_KEY, EMAIL_DESTINATAIRE_ACHATS.
    Ne modifie JAMAIS le statut a_commander ni la date de dernière commande :
    c'est l'utilisateur qui décoche manuellement une fois la commande passée.
    """
    articles = (
        db.query(ArticleAchat)
        .filter(ArticleAchat.a_commander == True)  # noqa: E712
        .order_by(ArticleAchat.magasin, ArticleAchat.nom)
        .all()
    )
    if not articles:
        raise HTTPException(status_code=400, detail="Aucun article coché à commander")

    resend_api_key = os.getenv("RESEND_API_KEY")
    destinataire = os.getenv("EMAIL_DESTINATAIRE_ACHATS")
    if not resend_api_key or not destinataire:
        raise HTTPException(
            status_code=500,
            detail="Configuration email manquante côté serveur (variables d'environnement Railway)",
        )

    # Regroupement par fournisseur, dans l'ordre alphabétique des fournisseurs
    par_magasin = {}
    for a in articles:
        cle = a.magasin or "Non classé"
        par_magasin.setdefault(cle, []).append(a)

    lignes = []
    total_general = 0.0
    for magasin in sorted(par_magasin.keys(), key=lambda s: s.lower()):
        lignes.append(magasin.upper())
        lignes.append("-" * len(magasin))
        for a in par_magasin[magasin]:
            prix = float(a.prix_achat) if a.prix_achat is not None else 0.0
            sous_total = prix * a.qte
            total_general += sous_total
            lignes.append(f"  {a.qte:>3} x {a.nom:<40} {sous_total:>8.2f} €")
        lignes.append("")
    lignes.append(f"TOTAL : {total_general:.2f} €")
    corps = "\n".join(lignes)
    corps_html = "<pre style=\"font-family: monospace; font-size: 14px;\">" + corps.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;") + "</pre>"

    payload = {
        "from": "Achats L'Olive <onboarding@resend.dev>",
        "to": [destinataire],
        "subject": "Liste d'achats - " + date_type.today().strftime("%d/%m/%Y"),
        "text": corps,
        "html": corps_html,
    }

    try:
        reponse = requests.post(
            "https://api.resend.com/emails",
            headers={"Authorization": "Bearer " + resend_api_key, "Content-Type": "application/json"},
            json=payload,
            timeout=15,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail="Erreur lors de l'envoi de l'email : " + str(e))

    if reponse.status_code >= 400:
        raise HTTPException(status_code=500, detail="Erreur Resend (" + str(reponse.status_code) + ") : " + reponse.text)

    return {"message": "Email envoyé avec " + str(len(articles)) + " article(s)"}