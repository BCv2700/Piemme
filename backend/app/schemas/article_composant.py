from pydantic import BaseModel
from typing import Optional
from decimal import Decimal

class ArticleComposantBase(BaseModel):
    article_id: int
    description: str
    prix: Decimal = Decimal("0")

class ArticleComposantCreate(ArticleComposantBase):
    pass

class ArticleComposantUpdate(BaseModel):
    description: Optional[str] = None
    prix: Optional[Decimal] = None

class ArticleComposantOut(ArticleComposantBase):
    id: int

    class Config:
        from_attributes = True