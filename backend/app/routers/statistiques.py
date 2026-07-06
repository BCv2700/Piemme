from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func, extract
from app.database import get_db
from app.models.encaissement import Encaissement
from app.models.encaissement_ligne import EncaissementLigne
from app.models.article import Article
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/statistiques", tags=["Statistiques"])


@router.get("/montants-annuels/{annee}")
def montants_annuels(
    annee: int,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    """
    Total des montants (hors dépenses) par jour du mois, pour chaque mois
    de l'année demandée. Retourne une liste de { jour, mois, total }.
    """
    lignes = (
        db.query(
            extract("day", Encaissement.date_encaissement).label("jour"),
            extract("month", Encaissement.date_encaissement).label("mois"),
            func.sum(Encaissement.montant_total).label("total"),
        )
        .filter(
            extract("year", Encaissement.date_encaissement) == annee,
            Encaissement.depenses == False,  # noqa: E712
        )
        .group_by("jour", "mois")
        .all()
    )
    return [
        {"jour": int(l.jour), "mois": int(l.mois), "total": float(l.total or 0)}
        for l in lignes
    ]


@router.get("/plats-demandes/{annee}")
def plats_demandes(
    annee: int,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    """
    Quantité vendue par article et par mois, pour l'année demandée.
    Regroupé par article_id (pas par nom texte, qui peut varier). Les
    encaissements de type dépenses sont exclus. Les lignes sans article_id
    (cas rare) sont ignorées plutôt que mal regroupées.
    Retourne une liste triée par quantité totale décroissante :
    [{ article_id, nom, mois: { "1": qte, ..., "12": qte }, total }]
    """
    lignes = (
        db.query(
            EncaissementLigne.article_id,
            extract("month", Encaissement.date_encaissement).label("mois"),
            func.sum(EncaissementLigne.quantite).label("quantite"),
        )
        .join(Encaissement, EncaissementLigne.encaissement_id == Encaissement.id)
        .filter(
            extract("year", Encaissement.date_encaissement) == annee,
            Encaissement.depenses == False,  # noqa: E712
            EncaissementLigne.article_id.isnot(None),
        )
        .group_by(EncaissementLigne.article_id, "mois")
        .all()
    )

    noms_articles = {a.id: a.nom for a in db.query(Article.id, Article.nom).all()}

    data = {}
    for article_id, mois, quantite in lignes:
        if article_id not in data:
            data[article_id] = {m: 0.0 for m in range(1, 13)}
        data[article_id][int(mois)] = float(quantite or 0)

    resultat = []
    for article_id, mois_dict in data.items():
        total = sum(mois_dict.values())
        resultat.append({
            "article_id": article_id,
            "nom": noms_articles.get(article_id, "(article supprimé)"),
            "mois": mois_dict,
            "total": total,
        })
    resultat.sort(key=lambda x: x["total"], reverse=True)
    return resultat