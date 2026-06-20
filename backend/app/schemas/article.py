from pydantic import BaseModel
from typing import Optional
from decimal import Decimal

class ArticleBase(BaseModel):
    nom: str
    categorie: Optional[str] = None
    type_article: Optional[str] = None
    tva: Decimal = Decimal("21")
    tva_away: Optional[Decimal] = None
    prix_achat: Decimal = Decimal("0")
    prix_vente: Decimal = Decimal("0")
    prix_vente_away: Optional[Decimal] = None
    stock: int = 0
    stock_min: int = 0
    stock_max: int = 0
    ean: Optional[str] = None
    fournisseur: Optional[str] = None
    localisation: Optional[str] = None
    actif: bool = True

class ArticleCreate(ArticleBase):
    pass

class ArticleUpdate(BaseModel):
    nom: Optional[str] = None
    categorie: Optional[str] = None
    type_article: Optional[str] = None
    tva: Optional[Decimal] = None
    tva_away: Optional[Decimal] = None
    prix_achat: Optional[Decimal] = None
    prix_vente: Optional[Decimal] = None
    prix_vente_away: Optional[Decimal] = None
    stock: Optional[int] = None
    stock_min: Optional[int] = None
    stock_max: Optional[int] = None
    ean: Optional[str] = None
    fournisseur: Optional[str] = None
    localisation: Optional[str] = None
    actif: Optional[bool] = None

class ArticleOut(ArticleBase):
    id: int

    class Config:
        from_attributes = True
