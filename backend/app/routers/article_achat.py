from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date as date_type
import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

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


@router.post("/envoyer-commande")
def envoyer_commande(db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Envoie par email la liste des articles cochés "à commander" (a_commander=True),
    groupée par fournisseur. Compte d'envoi Gmail configuré via variables
    d'environnement Railway : GMAIL_ADDRESS, GMAIL_APP_PASSWORD,
    EMAIL_DESTINATAIRE_ACHATS.
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

    gmail_address = os.getenv("GMAIL_ADDRESS")
    gmail_password = os.getenv("GMAIL_APP_PASSWORD")
    destinataire = os.getenv("EMAIL_DESTINATAIRE_ACHATS")
    if not gmail_address or not gmail_password or not destinataire:
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

    msg = MIMEMultipart()
    msg["From"] = gmail_address
    msg["To"] = destinataire
    msg["Subject"] = "Liste d'achats - " + date_type.today().strftime("%d/%m/%Y")
    msg.attach(MIMEText(corps, "plain"))

    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
            server.login(gmail_address, gmail_password)
            server.sendmail(gmail_address, destinataire, msg.as_string())
    except Exception as e:
        raise HTTPException(status_code=500, detail="Erreur lors de l'envoi de l'email : " + str(e))

    return {"message": "Email envoyé avec " + str(len(articles)) + " article(s)"}