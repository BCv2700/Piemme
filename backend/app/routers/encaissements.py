from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date, datetime
from typing import Optional
from app.database import get_db
from app.models.encaissement import Encaissement
from app.models.encaissement_ligne import EncaissementLigne
from app.models.commande import Commande
from app.models.table import Table
from app.schemas.encaissement import EncaissementOut, EncaissementCreate

router = APIRouter(prefix="/encaissements", tags=["Encaissements"])

@router.get("/", response_model=list[EncaissementOut])
def list_encaissements(
    date_debut: Optional[date] = None,
    date_fin: Optional[date] = None,
    db: Session = Depends(get_db),
):
    query = db.query(Encaissement)
    if date_debut:
        query = query.filter(Encaissement.date_encaissement >= date_debut)
    if date_fin:
        query = query.filter(Encaissement.date_encaissement <= date_fin)
    return query.order_by(Encaissement.date_encaissement.desc()).all()

@router.get("/{encaissement_id}", response_model=EncaissementOut)
def get_encaissement(encaissement_id: int, db: Session = Depends(get_db)):
    enc = db.query(Encaissement).filter(Encaissement.id == encaissement_id).first()
    if not enc:
        raise HTTPException(status_code=404, detail="Encaissement introuvable")
    return enc

@router.post("/", response_model=EncaissementOut)
def create_encaissement(payload: EncaissementCreate, db: Session = Depends(get_db)):
    """
    Finalise le paiement d'une table : crée l'encaissement + ses lignes,
    puis vide le caddy (commandes) de la table et la repasse à 'libre'.
    """
    data = payload.dict(exclude={"lignes"})
    db_encaissement = Encaissement(**data)
    db.add(db_encaissement)
    db.flush()  # pour obtenir db_encaissement.id avant le commit

    for ligne in payload.lignes:
        db_ligne = EncaissementLigne(encaissement_id=db_encaissement.id, **ligne.dict())
        db.add(db_ligne)

    # Vide le caddy de la table concernée, si renseignée
    if payload.table_nom:
        table = db.query(Table).filter(Table.nom == payload.table_nom).first()
        if table:
            db.query(Commande).filter(Commande.table_id == table.id).delete()
            table.statut = 'libre'

    db.commit()
    db.refresh(db_encaissement)
    return db_encaissement
