from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.recap_mensuel import RecapMensuel
from app.schemas.recap_mensuel import (
    RecapMensuelOut,
    RecapMensuelUpdate,
)

router = APIRouter(prefix="/recap-mensuel", tags=["Récap mensuel"])


@router.get("/annee/{annee}", response_model=list[RecapMensuelOut])
def get_recap_annee(annee: int, db: Session = Depends(get_db)):
    """
    Renvoie tous les récaps mensuels existants pour une année donnée (1 à 12
    entrées selon ce qui a déjà été consulté/modifié). Les mois sans entrée en
    base ne sont PAS créés ici : le frontend applique alors les valeurs par
    défaut (km_defaut = 53.4, aucune exception), comme pour le récap mensuel
    classique.
    """
    return (
        db.query(RecapMensuel)
        .filter(RecapMensuel.annee == annee)
        .order_by(RecapMensuel.mois)
        .all()
    )


@router.get("/{annee}/{mois}", response_model=RecapMensuelOut)
def get_recap(annee: int, mois: int, db: Session = Depends(get_db)):
    """
    Renvoie le récap (mémo + km + fermé) d'un mois donné.
    Si aucun récap n'existe encore pour ce mois, en crée un avec les valeurs
    par défaut (mémo vide, km_defaut = 53.4) puis le renvoie.
    """
    recap = (
        db.query(RecapMensuel)
        .filter(RecapMensuel.annee == annee, RecapMensuel.mois == mois)
        .first()
    )
    if not recap:
        recap = RecapMensuel(annee=annee, mois=mois, memo='', km_par_jour={}, ferme_par_jour={})
        db.add(recap)
        db.commit()
        db.refresh(recap)
    return recap


@router.patch("/{annee}/{mois}", response_model=RecapMensuelOut)
def update_recap(annee: int, mois: int, payload: RecapMensuelUpdate, db: Session = Depends(get_db)):
    """
    Met à jour le mémo, les km et/ou les jours fermés d'un mois. Crée la ligne du mois si besoin.
    """
    recap = (
        db.query(RecapMensuel)
        .filter(RecapMensuel.annee == annee, RecapMensuel.mois == mois)
        .first()
    )
    if not recap:
        recap = RecapMensuel(annee=annee, mois=mois, memo='', km_par_jour={}, ferme_par_jour={})
        db.add(recap)
        db.flush()

    data = payload.dict(exclude_unset=True)
    # JSONB : on convertit les Decimal en float pour un stockage propre
    if 'km_par_jour' in data and data['km_par_jour'] is not None:
        data['km_par_jour'] = {k: float(v) for k, v in data['km_par_jour'].items()}
    for key, value in data.items():
        setattr(recap, key, value)

    db.commit()
    db.refresh(recap)
    return recap