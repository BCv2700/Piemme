from pydantic import BaseModel
from typing import Optional
from decimal import Decimal

class ArticleBase(BaseModel):
    nom: str
    categorie: Optional[str] = None
    type_article: Optional[str] = None
    code_vente: Optional[int] = None
    tva: Decimal = Decimal("21")
    tva_away: Optional[Decimal] = None
    prix_achat: Decimal = Decimal("0")
    prix_vente: Decimal = Decimal("0")
    prix_vente_away: Optional[Decimal] = None
    stock: int = 0
    stock_min: int = 0
    stock_max: int = 0
    stock_a_suivre: bool = False
    est_boisson: bool = False
    ean: Optional[str] = None
    fournisseur: Optional[str] = None
    localisation: Optional[str] = None
    actif: bool = True
    # 'vente' (défaut) ou 'depense' : détermine si l'article apparaît dans le
    # Caddy d'une table de salle classique ou uniquement sur la table DÉPENSES
    type: str = "vente"

class ArticleCreate(ArticleBase):
    pass

class ArticleUpdate(BaseModel):
    nom: Optional[str] = None
    categorie: Optional[str] = None
    type_article: Optional[str] = None
    code_vente: Optional[int] = None
    tva: Optional[Decimal] = None
    tva_away: Optional[Decimal] = None
    prix_achat: Optional[Decimal] = None
    prix_vente: Optional[Decimal] = None
    prix_vente_away: Optional[Decimal] = None
    stock: Optional[int] = None
    stock_min: Optional[int] = None
    stock_max: Optional[int] = None
    stock_a_suivre: Optional[bool] = None
    est_boisson: Optional[bool] = None
    ean: Optional[str] = None
    fournisseur: Optional[str] = None
    localisation: Optional[str] = None
    actif: Optional[bool] = None
    type: Optional[str] = None

class ArticleOut(ArticleBase):
    id: int

    class Config:
        from_attributes = True
