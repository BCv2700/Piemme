from sqlalchemy import Column, Integer, String, Boolean, Numeric
from app.database import Base

class Article(Base):
    __tablename__ = 'articles'
    id               = Column(Integer, primary_key=True, index=True)
    nom              = Column(String(100), nullable=False)
    categorie        = Column(String(50))
    type_article     = Column(String(50))
    code_vente       = Column(Integer)
    tva              = Column(Numeric(5,2), default=21)
    tva_away         = Column(Numeric(5,2))
    prix_achat       = Column(Numeric(10,2), default=0)
    prix_vente       = Column(Numeric(10,2), nullable=False, default=0)
    prix_vente_away  = Column(Numeric(10,2))
    stock            = Column(Integer, default=0)
    stock_min        = Column(Integer, default=0)
    stock_max        = Column(Integer, default=0)
    ean              = Column(String(20))
    fournisseur      = Column(String(100))
    localisation     = Column(String(100))
    actif            = Column(Boolean, default=True)
