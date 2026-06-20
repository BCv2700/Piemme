from pydantic import BaseModel
from typing import Optional
from datetime import date

class ClientBase(BaseModel):
    nom: str
    telephone: Optional[str] = None
    email: Optional[str] = None
    adresse: Optional[str] = None
    cp: Optional[str] = None
    localite: Optional[str] = None
    date_anniversaire: Optional[date] = None
    derniere_visite: Optional[date] = None
    a_recontacter: bool = False
    remarques: Optional[str] = None
    actif: bool = True

class ClientCreate(ClientBase):
    pass

class ClientUpdate(BaseModel):
    nom: Optional[str] = None
    telephone: Optional[str] = None
    email: Optional[str] = None
    adresse: Optional[str] = None
    cp: Optional[str] = None
    localite: Optional[str] = None
    date_anniversaire: Optional[date] = None
    derniere_visite: Optional[date] = None
    a_recontacter: Optional[bool] = None
    remarques: Optional[str] = None
    actif: Optional[bool] = None

class ClientOut(ClientBase):
    id: int

    class Config:
        from_attributes = True
