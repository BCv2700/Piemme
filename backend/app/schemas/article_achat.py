from pydantic import BaseModel
from typing import Optional
from decimal import Decimal
from datetime import date as date_type

class ArticleAchatBase(BaseModel):
    nom: str
    qte: int = 0
    prix_achat: Optional[Decimal] = None
    magasin: Optional[str] = None
    a_commander: bool = False
    date_derniere_commande: Optional[date_type] = None

class ArticleAchatCreate(ArticleAchatBase):
    pass

class ArticleAchatUpdate(BaseModel):
    nom: Optional[str] = None
    qte: Optional[int] = None
    prix_achat: Optional[Decimal] = None
    magasin: Optional[str] = None
    a_commander: Optional[bool] = None
    date_derniere_commande: Optional[date_type] = None

class ArticleAchatOut(ArticleAchatBase):
    id: int

    class Config:
        from_attributes = True