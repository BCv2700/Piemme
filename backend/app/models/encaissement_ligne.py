from sqlalchemy import Column, Integer, String, Numeric, ForeignKey
from app.database import Base

class EncaissementLigne(Base):
    __tablename__ = 'encaissement_lignes'
    id                = Column(Integer, primary_key=True, index=True)
    encaissement_id   = Column(Integer, ForeignKey('encaissements.id'), nullable=False)
    article_id        = Column(Integer, ForeignKey('articles.id'))
    article_nom       = Column(String(100), nullable=False)
    quantite          = Column(Numeric(10,2), nullable=False, default=1)
    prix_vente        = Column(Numeric(10,2), nullable=False)
    tva               = Column(Numeric(5,2), nullable=False)
