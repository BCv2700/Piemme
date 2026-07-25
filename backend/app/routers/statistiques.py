from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func, extract
from app.database import get_db
from app.models.encaissement import Encaissement
from app.models.encaissement_ligne import EncaissementLigne
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
    from app.models.article import Article
    lignes = (
        db.query(
            EncaissementLigne.article_nom,
            extract("month", Encaissement.date_encaissement).label("mois"),
            func.sum(EncaissementLigne.quantite).label("quantite"),
            Article.code_vente.label("code_vente"),
        )
        .join(Encaissement, EncaissementLigne.encaissement_id == Encaissement.id)
        .outerjoin(Article, EncaissementLigne.article_id == Article.id)
        .filter(
            extract("year", Encaissement.date_encaissement) == annee,
            Encaissement.depenses == False,  # noqa: E712
            EncaissementLigne.article_nom.isnot(None),
        )
        .group_by(EncaissementLigne.article_nom, "mois", Article.code_vente)
        .all()
    )

    data = {}
    for nom, mois, quantite, code_vente in lignes:
        if nom not in data:
            data[nom] = {"mois": {m: 0.0 for m in range(1, 13)}, "code_vente": code_vente}
        data[nom]["mois"][int(mois)] = float(quantite or 0)
        if data[nom]["code_vente"] is None and code_vente is not None:
            data[nom]["code_vente"] = code_vente

    resultat = []
    for nom, info in data.items():
        total = sum(info["mois"].values())
        resultat.append({
            "nom": nom,
            "mois": info["mois"],
            "total": total,
            "code_vente": info["code_vente"],
        })
    resultat.sort(key=lambda x: x["total"], reverse=True)
    return resultat

@router.get("/frequentation/{annee}")
def frequentation(
    annee: int,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    """
    Somme du nombre de personnes par jour du mois, pour chaque mois de
    l'année demandée. Exclut les dépenses et les commandes à emporter
    (emporte = true). Retourne une liste de { jour, mois, total }.
    """
    lignes = (
        db.query(
            extract("day", Encaissement.date_encaissement).label("jour"),
            extract("month", Encaissement.date_encaissement).label("mois"),
            func.sum(Encaissement.nb_personnes).label("total"),
        )
        .filter(
            extract("year", Encaissement.date_encaissement) == annee,
            Encaissement.depenses == False,  # noqa: E712
            Encaissement.emporte == False,  # noqa: E712
        )
        .group_by("jour", "mois")
        .all()
    )
    return [
        {"jour": int(l.jour), "mois": int(l.mois), "total": int(l.total or 0)}
        for l in lignes
    ]