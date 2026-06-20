from pydantic import BaseModel
from typing import Optional, List
from decimal import Decimal
from datetime import datetime

class EncaissementLigneBase(BaseModel):
    article_id: Optional[int] = None
    article_nom: str
    quantite: Decimal = Decimal("1")
    prix_vente: Decimal
    tva: Decimal

class EncaissementLigneOut(EncaissementLigneBase):
    id: int
    encaissement_id: int

    class Config:
        from_attributes = True

class EncaissementBase(BaseModel):
    table_nom: Optional[str] = None
    client_id: Optional[int] = None
    montant_carte: Decimal = Decimal("0")
    montant_cash: Decimal = Decimal("0")
    montant_total: Decimal = Decimal("0")
    nb_personnes: int = 1
    emporte: bool = False
    depenses: bool = False
    serveur: Optional[str] = None
    remarque: Optional[str] = None

class EncaissementCreate(EncaissementBase):
    lignes: List[EncaissementLigneBase] = []

class EncaissementOut(EncaissementBase):
    id: int
    date_encaissement: datetime
    lignes: List[EncaissementLigneOut] = []

    class Config:
        from_attributes = True
