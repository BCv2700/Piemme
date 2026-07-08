from sqlalchemy import Column, Integer, String, Numeric, Date, Time, Text, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

class ServicePersonnel(Base):
    __tablename__ = 'service_personnel'
    id              = Column(Integer, primary_key=True, index=True)
    nom             = Column(String(100), nullable=False)
    date_service    = Column(Date, nullable=False)
    heure_debut     = Column(Time, nullable=False)
    heure_fin       = Column(Time, nullable=False)
    taux_horaire    = Column(Numeric(10, 2), nullable=False, default=15)
    montant         = Column(Numeric(10, 2), nullable=False)
    type_paiement   = Column(String(10), nullable=False)  # 'cash' ou 'tiers'
    encaissement_id = Column(Integer, ForeignKey('encaissements.id', ondelete='CASCADE'))
    remarque        = Column(Text)
    created_at      = Column(DateTime, server_default=func.now())