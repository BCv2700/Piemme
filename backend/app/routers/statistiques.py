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
    """
    Quantité vendue par plat et par mois, pour l'année demandée.
    Regroupé par article_nom (texte archivé sur la ligne), car article_id
    n'a été renseigné systématiquement qu'à partir de mai/juin 2026 : un
    regroupement par article_id exclurait silencieusement tout l'historique
    antérieur. Les encaissements de type dépenses sont exclus.
    Retourne une liste triée par quantité totale décroissante :
    [{ nom, mois: { "1": qte, ..., "12": qte }, total }]
    """
    lignes = (
        db.query(
            EncaissementLigne.article_nom,
            extract("month", Encaissement.date_encaissement).label("mois"),
            func.sum(EncaissementLigne.quantite).label("quantite"),
        )
        .join(Encaissement, EncaissementLigne.encaissement_id == Encaissement.id)
        .filter(
            extract("year", Encaissement.date_encaissement) == annee,
            Encaissement.depenses == False,  # noqa: E712
            EncaissementLigne.article_nom.isnot(None),
        )
        .group_by(EncaissementLigne.article_nom, "mois")
        .all()
    )

    data = {}
    for nom, mois, quantite in lignes:
        if nom not in data:
            data[nom] = {m: 0.0 for m in range(1, 13)}
        data[nom][int(mois)] = float(quantite or 0)

    resultat = []
    for nom, mois_dict in data.items():
        total = sum(mois_dict.values())
        resultat.append({
            "nom": nom,
            "mois": mois_dict,
            "total": total,
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