from sqlalchemy import Column, Integer, String, Boolean, Date, Text
from app.database import Base

class Client(Base):
    __tablename__ = 'clients'
    id                 = Column(Integer, primary_key=True, index=True)
    nom                = Column(String(100), nullable=False)
    telephone          = Column(String(30))
    email              = Column(String(100))
    adresse            = Column(String(150))
    cp                 = Column(String(10))
    localite           = Column(String(100))
    date_anniversaire  = Column(Date)
    derniere_visite    = Column(Date)
    a_recontacter      = Column(Boolean, default=False)
    remarques          = Column(Text)
    actif              = Column(Boolean, default=True)
