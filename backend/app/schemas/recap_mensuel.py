from pydantic import BaseModel
from typing import Optional, Dict
from decimal import Decimal


class RecapMensuelBase(BaseModel):
    annee: int
    mois: int
    memo: Optional[str] = ""
    km_defaut: Decimal = Decimal("53.4")
    km_par_jour: Optional[Dict[str, Decimal]] = {}
    ferme_par_jour: Optional[Dict[str, bool]] = {}


class RecapMensuelUpdate(BaseModel):
    memo: Optional[str] = None
    km_defaut: Optional[Decimal] = None
    km_par_jour: Optional[Dict[str, Decimal]] = None
    ferme_par_jour: Optional[Dict[str, bool]] = None


class RecapMensuelOut(RecapMensuelBase):
    id: int

    class Config:
        from_attributes = True