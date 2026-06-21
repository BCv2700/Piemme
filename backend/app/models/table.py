from sqlalchemy import Column, Integer, String, DateTime
from app.database import Base

class Table(Base):
    __tablename__ = 'tables'
    id               = Column(Integer, primary_key=True, index=True)
    nom              = Column(String(10), nullable=False, unique=True)
    capacite         = Column(Integer, default=2)
    pos_x            = Column(Integer, default=0)
    pos_y            = Column(Integer, default=0)
    forme            = Column(String(10), default='rect')
    statut           = Column(String(20), default='libre')
    nom_reservation  = Column(String(100), nullable=True)
    heure_arrivee    = Column(DateTime, nullable=True)
