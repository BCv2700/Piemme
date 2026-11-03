from sqlalchemy import Column, Integer, String, Boolean
from app.database import Base


class Utilisateur(Base):
    __tablename__ = 'utilisateurs'

    id           = Column(Integer, primary_key=True, index=True)
    username     = Column(String, unique=True, nullable=False, index=True)
    mot_de_passe = Column(String, nullable=False)
    actif        = Column(Boolean, default=True)
    role         = Column(String, nullable=False, default='admin')
