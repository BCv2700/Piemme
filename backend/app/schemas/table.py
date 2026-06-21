from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class TableBase(BaseModel):
    nom: str
    capacite: int = 2
    pos_x: int = 0
    pos_y: int = 0
    forme: str = 'rect'
    statut: str = 'libre'
    nom_reservation: Optional[str] = None
    heure_arrivee: Optional[datetime] = None

class TableCreate(TableBase):
    pass

class TableUpdate(BaseModel):
    nom: Optional[str] = None
    capacite: Optional[int] = None
    pos_x: Optional[int] = None
    pos_y: Optional[int] = None
    forme: Optional[str] = None
    statut: Optional[str] = None
    nom_reservation: Optional[str] = None
    heure_arrivee: Optional[datetime] = None

class TableOut(TableBase):
    id: int

    class Config:
        from_attributes = True
