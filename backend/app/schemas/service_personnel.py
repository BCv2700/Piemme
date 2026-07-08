from pydantic import BaseModel
from typing import Optional
from decimal import Decimal
from datetime import date, time, datetime

class ServicePersonnelBase(BaseModel):
    nom: str
    date_service: date
    heure_debut: time
    heure_fin: time
    taux_horaire: Decimal = Decimal("15")
    montant: Decimal
    type_paiement: str  # 'cash' ou 'tiers'
    remarque: Optional[str] = None

class ServicePersonnelCreate(ServicePersonnelBase):
    pass

class ServicePersonnelUpdate(BaseModel):
    nom: Optional[str] = None
    date_service: Optional[date] = None
    heure_debut: Optional[time] = None
    heure_fin: Optional[time] = None
    taux_horaire: Optional[Decimal] = None
    montant: Optional[Decimal] = None
    type_paiement: Optional[str] = None
    remarque: Optional[str] = None

class ServicePersonnelOut(ServicePersonnelBase):
    id: int
    encaissement_id: Optional[int] = None
    created_at: datetime

    class Config:
        from_attributes = True
