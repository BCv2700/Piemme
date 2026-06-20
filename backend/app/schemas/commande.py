from pydantic import BaseModel
from typing import Optional
from decimal import Decimal
from datetime import datetime

class CommandeBase(BaseModel):
    table_id: int
    article_id: int
    quantite: Decimal = Decimal("1")
    prix_unitaire: Decimal
    tva: Decimal
    serveur: Optional[str] = None
    imprime: bool = False
    emporte: bool = False

class CommandeCreate(CommandeBase):
    pass

class CommandeUpdate(BaseModel):
    quantite: Optional[Decimal] = None
    imprime: Optional[bool] = None
    emporte: Optional[bool] = None

class CommandeOut(CommandeBase):
    id: int
    date_commande: datetime

    class Config:
        from_attributes = True
