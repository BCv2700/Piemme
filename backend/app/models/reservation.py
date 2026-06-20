from sqlalchemy import Column, Integer, String, Date, Time, Text, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

class Reservation(Base):
    __tablename__ = 'reservations'
    id                  = Column(Integer, primary_key=True, index=True)
    table_id            = Column(Integer, ForeignKey('tables.id'))
    client_id           = Column(Integer, ForeignKey('clients.id'))
    nom_client          = Column(String(100), nullable=False)
    date_reservation    = Column(Date, nullable=False)
    heure               = Column(Time, nullable=False)
    nb_personnes        = Column(Integer, default=2)
    remarque            = Column(Text)
    statut              = Column(String(20), default='confirmee')
    created_at          = Column(DateTime, server_default=func.now())
