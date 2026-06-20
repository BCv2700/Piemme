from sqlalchemy import Column, Integer, String, Boolean, Numeric, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

class Commande(Base):
    __tablename__ = 'commandes'
    id              = Column(Integer, primary_key=True, index=True)
    table_id        = Column(Integer, ForeignKey('tables.id'), nullable=False)
    article_id      = Column(Integer, ForeignKey('articles.id'), nullable=False)
    quantite        = Column(Numeric(10,2), nullable=False, default=1)
    prix_unitaire   = Column(Numeric(10,2), nullable=False)
    tva             = Column(Numeric(5,2), nullable=False)
    serveur         = Column(String(50))
    imprime         = Column(Boolean, default=False)
    emporte         = Column(Boolean, default=False)
    date_commande   = Column(DateTime, server_default=func.now())
