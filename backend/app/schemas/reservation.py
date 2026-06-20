from pydantic import BaseModel
from typing import Optional
from datetime import date, time, datetime

class ReservationBase(BaseModel):
    table_id: Optional[int] = None
    client_id: Optional[int] = None
    nom_client: str
    date_reservation: date
    heure: time
    nb_personnes: int = 2
    remarque: Optional[str] = None
    statut: str = 'confirmee'

class ReservationCreate(ReservationBase):
    pass

class ReservationUpdate(BaseModel):
    table_id: Optional[int] = None
    client_id: Optional[int] = None
    nom_client: Optional[str] = None
    date_reservation: Optional[date] = None
    heure: Optional[time] = None
    nb_personnes: Optional[int] = None
    remarque: Optional[str] = None
    statut: Optional[str] = None

class ReservationOut(ReservationBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
