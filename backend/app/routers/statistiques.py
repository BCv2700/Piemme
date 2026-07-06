from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func, extract
from app.database import get_db
from app.models.encaissement import Encaissement
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