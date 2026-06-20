from sqlalchemy import Column, Integer, String, Boolean, Numeric, DateTime, Text, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

class Encaissement(Base):
    __tablename__ = 'encaissements'
    id                  = Column(Integer, primary_key=True, index=True)
    table_nom           = Column(String(10))
    client_id           = Column(Integer, ForeignKey('clients.id'))
    montant_carte       = Column(Numeric(10,2), default=0)
    montant_cash        = Column(Numeric(10,2), default=0)
    montant_total       = Column(Numeric(10,2), nullable=False, default=0)
    nb_personnes        = Column(Integer, default=1)
    emporte             = Column(Boolean, default=False)
    depenses            = Column(Boolean, default=False)
    serveur             = Column(String(50))
    date_encaissement   = Column(DateTime, server_default=func.now())
    remarque            = Column(Text)
