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
    vente_analysee: bool = False

class EncaissementLigneOut(EncaissementLigneBase):
    id: int
    encaissement_id: int

    class Config:
        from_attributes = True

class EncaissementLigneUpdate(BaseModel):
    article_id: Optional[int] = None
    article_nom: Optional[str] = None
    quantite: Optional[Decimal] = None
    prix_vente: Optional[Decimal] = None
    tva: Optional[Decimal] = None
    vente_analysee: Optional[bool] = None

class EncaissementLigneCreate(EncaissementLigneBase):
    pass

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
    cash_analyse: Decimal = Decimal("0")
    nom_reservation_archive: Optional[str] = None

class EncaissementCreate(EncaissementBase):
    date_encaissement: Optional[datetime] = None
    lignes: List[EncaissementLigneBase] = []

class EncaissementUpdate(BaseModel):
    table_nom: Optional[str] = None
    client_id: Optional[int] = None
    montant_carte: Optional[Decimal] = None
    montant_cash: Optional[Decimal] = None
    montant_total: Optional[Decimal] = None
    nb_personnes: Optional[int] = None
    emporte: Optional[bool] = None
    depenses: Optional[bool] = None
    serveur: Optional[str] = None
    remarque: Optional[str] = None
    date_encaissement: Optional[datetime] = None
    cash_analyse: Optional[Decimal] = None
    nom_reservation_archive: Optional[str] = None

class EncaissementOut(EncaissementBase):
    id: int
    date_encaissement: datetime
    lignes: List[EncaissementLigneOut] = []

    class Config:
        from_attributes = True