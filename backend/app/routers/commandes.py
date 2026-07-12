from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.commande import Commande
from app.models.table import Table
from app.schemas.commande import CommandeOut, CommandeCreate, CommandeUpdate
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/commandes", tags=["Commandes"])

@router.get("/", response_model=list[CommandeOut])
def list_commandes(table_id: int = None, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """Liste les lignes de commande en cours. Filtrable par table (le caddy d'une table)."""
    query = db.query(Commande)
    if table_id is not None:
        query = query.filter(Commande.table_id == table_id)
    return query.order_by(Commande.date_commande).all()

@router.post("/", response_model=CommandeOut)
def create_commande(commande: CommandeCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
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
def update_commande(commande_id: int, commande: CommandeUpdate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_commande = db.query(Commande).filter(Commande.id == commande_id).first()
    if not db_commande:
        raise HTTPException(status_code=404, detail="Ligne de commande introuvable")

    updates = commande.dict(exclude_unset=True)
    ancien_table_id = db_commande.table_id
    nouveau_table_id = updates.get("table_id")

    for key, value in updates.items():
        setattr(db_commande, key, value)
    db.commit()
    db.refresh(db_commande)

    # Si la ligne change de table (réattribution depuis le Caddy), on met à
    # jour le statut occupée/libre des deux tables concernées : l'ancienne
    # est libérée si elle n'a plus aucune ligne, la nouvelle passe occupée
    # si elle était libre. Sans ça, une table pouvait rester "occupée" sur le
    # plan de salle après en avoir déplacé tout le contenu ailleurs.
    if nouveau_table_id is not None and nouveau_table_id != ancien_table_id:
        lignes_restantes_ancienne = db.query(Commande).filter(Commande.table_id == ancien_table_id).count()
        if lignes_restantes_ancienne == 0:
            ancienne_table = db.query(Table).filter(Table.id == ancien_table_id).first()
            if ancienne_table and ancienne_table.statut == 'occupee':
                ancienne_table.statut = 'libre'

        nouvelle_table = db.query(Table).filter(Table.id == nouveau_table_id).first()
        if nouvelle_table and nouvelle_table.statut == 'libre':
            nouvelle_table.statut = 'occupee'

        db.commit()
        db.refresh(db_commande)

    return db_commande

@router.delete("/{commande_id}")
def delete_commande(commande_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_commande = db.query(Commande).filter(Commande.id == commande_id).first()
    if not db_commande:
        raise HTTPException(status_code=404, detail="Ligne de commande introuvable")
    table_id = db_commande.table_id
    db.delete(db_commande)
    db.flush()

    # Si cette suppression vide entièrement le caddy de la table (dernier
    # article retiré sans passer par le paiement, ex: ajout puis annulation),
    # on libère la table plutôt que de la laisser "occupée" indéfiniment.
    # Corrige un bug où une table restait rouge sur le plan de salle après
    # une commande annulée avant paiement.
    lignes_restantes = db.query(Commande).filter(Commande.table_id == table_id).count()
    if lignes_restantes == 0:
        table = db.query(Table).filter(Table.id == table_id).first()
        if table and table.statut == 'occupee':
            table.statut = 'libre'

    db.commit()
    return {"message": "Ligne supprimée"}

@router.delete("/table/{table_id}")
def clear_commandes_table(table_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """Vide le caddy d'une table (utilisé après paiement)."""
    db.query(Commande).filter(Commande.table_id == table_id).delete()
    table = db.query(Table).filter(Table.id == table_id).first()
    if table:
        table.statut = 'libre'
    db.commit()
    return {"message": "Caddy vidé, table libérée"}