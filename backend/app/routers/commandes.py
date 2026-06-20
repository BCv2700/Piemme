from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.commande import Commande
from app.models.table import Table
from app.schemas.commande import CommandeOut, CommandeCreate, CommandeUpdate

router = APIRouter(prefix="/commandes", tags=["Commandes"])

@router.get("/", response_model=list[CommandeOut])
def list_commandes(table_id: int = None, db: Session = Depends(get_db)):
    """Liste les lignes de commande en cours. Filtrable par table (le caddy d'une table)."""
    query = db.query(Commande)
    if table_id is not None:
        query = query.filter(Commande.table_id == table_id)
    return query.order_by(Commande.date_commande).all()

@router.post("/", response_model=CommandeOut)
def create_commande(commande: CommandeCreate, db: Session = Depends(get_db)):
    db_commande = Commande(**commande.dict())
    db.add(db_commande)

    # Marque la table comme occupée dès qu'une commande y est ajoutée
    table = db.query(Table).filter(Table.id == commande.table_id).first()
    if table and table.statut == 'libre':
        table.statut = 'occupee'

    db.commit()
    db.refresh(db_commande)
    return db_commande

@router.patch("/{commande_id}", response_model=CommandeOut)
def update_commande(commande_id: int, commande: CommandeUpdate, db: Session = Depends(get_db)):
    db_commande = db.query(Commande).filter(Commande.id == commande_id).first()
    if not db_commande:
        raise HTTPException(status_code=404, detail="Ligne de commande introuvable")
    for key, value in commande.dict(exclude_unset=True).items():
        setattr(db_commande, key, value)
    db.commit()
    db.refresh(db_commande)
    return db_commande

@router.delete("/{commande_id}")
def delete_commande(commande_id: int, db: Session = Depends(get_db)):
    db_commande = db.query(Commande).filter(Commande.id == commande_id).first()
    if not db_commande:
        raise HTTPException(status_code=404, detail="Ligne de commande introuvable")
    db.delete(db_commande)
    db.commit()
    return {"message": "Ligne supprimée"}

@router.delete("/table/{table_id}")
def clear_commandes_table(table_id: int, db: Session = Depends(get_db)):
    """Vide le caddy d'une table (utilisé après paiement)."""
    db.query(Commande).filter(Commande.table_id == table_id).delete()
    table = db.query(Table).filter(Table.id == table_id).first()
    if table:
        table.statut = 'libre'
    db.commit()
    return {"message": "Caddy vidé, table libérée"}
