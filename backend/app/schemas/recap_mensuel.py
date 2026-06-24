from pydantic import BaseModel
from typing import Optional, Dict
from decimal import Decimal


class RecapMensuelBase(BaseModel):
    annee: int
    mois: int
    memo: Optional[str] = ''
    km_defaut: Decimal = Decimal('53.4')
    # Exceptions de km par jour : { "4": 0, "11": 0 }
    km_par_jour: Dict[str, Decimal] = {}


class RecapMensuelCreate(RecapMensuelBase):
    pass


class RecapMensuelUpdate(BaseModel):
    memo: Optional[str] = None
    km_defaut: Optional[Decimal] = None
    km_par_jour: Optional[Dict[str, Decimal]] = None


class RecapMensuelOut(RecapMensuelBase):
    id: int

    class Config:
        from_attributes = True