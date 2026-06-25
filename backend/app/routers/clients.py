from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.models.client import Client
from app.schemas.client import ClientOut, ClientCreate, ClientUpdate
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/clients", tags=["Clients"])

@router.get("/", response_model=list[ClientOut])
def list_clients(
    search: Optional[str] = None,
    actif: Optional[bool] = None,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    query = db.query(Client)
    if search:
        query = query.filter(
            (Client.nom.ilike(f"%{search}%")) | (Client.telephone.ilike(f"%{search}%"))
        )
    if actif is not None:
        query = query.filter(Client.actif == actif)
    return query.order_by(Client.nom).all()

@router.get("/{client_id}", response_model=ClientOut)
def get_client(client_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    client = db.query(Client).filter(Client.id == client_id).first()
    if not client:
        raise HTTPException(status_code=404, detail="Client introuvable")
    return client

@router.post("/", response_model=ClientOut)
def create_client(client: ClientCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_client = Client(**client.dict())
    db.add(db_client)
    db.commit()
    db.refresh(db_client)
    return db_client

@router.patch("/{client_id}", response_model=ClientOut)
def update_client(client_id: int, client: ClientUpdate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_client = db.query(Client).filter(Client.id == client_id).first()
    if not db_client:
        raise HTTPException(status_code=404, detail="Client introuvable")
    for key, value in client.dict(exclude_unset=True).items():
        setattr(db_client, key, value)
    db.commit()
    db.refresh(db_client)
    return db_client

@router.delete("/{client_id}")
def delete_client(client_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_client = db.query(Client).filter(Client.id == client_id).first()
    if not db_client:
        raise HTTPException(status_code=404, detail="Client introuvable")
    db.delete(db_client)
    db.commit()
    return {"message": "Client supprimé"}