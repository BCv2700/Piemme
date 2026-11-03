from sqlalchemy import Column, Integer, String, Numeric, Date, Boolean, DateTime
from sqlalchemy.sql import func
from app.database import Base


class PiemmeJour(Base):
    __tablename__ = "piemme_jour"

    id = Column(Integer, primary_key=True, index=True)
    date = Column(Date, nullable=False, unique=True, index=True)
    recette = Column(Numeric(10, 2), default=0, nullable=False)
    depense = Column(Numeric(10, 2), default=0, nullable=False)
    remarque = Column(String(255), nullable=True)


class PiemmeDepenseRecurrente(Base):
    __tablename__ = "piemme_depense_recurrente"

    id = Column(Integer, primary_key=True, index=True)
    libelle = Column(String(200), nullable=False)
    montant = Column(Numeric(10, 2), default=0, nullable=False)
    actif = Column(Boolean, default=True, nullable=False)
    date_echeance = Column(Date, nullable=True)
    jour_du_mois = Column(Integer, nullable=True)
    email_envoye_mois = Column(String(7), nullable=True)


class PiemmeConfig(Base):
    __tablename__ = "piemme_config"

    id = Column(Integer, primary_key=True, index=True)
    annee = Column(Integer, nullable=False)
    mois = Column(Integer, nullable=False)
    pct_economie = Column(Numeric(5, 2), default=15, nullable=False)


class PiemmeDepenseDetail(Base):
    __tablename__ = "piemme_depense_detail"

    id = Column(Integer, primary_key=True, index=True)
    date = Column(Date, nullable=False, index=True)
    montant = Column(Numeric(10, 2), default=0, nullable=False)
    libelle = Column(String(200), nullable=True)
    paye = Column(Boolean, default=False, nullable=False, server_default="false")
    coefficient = Column(Numeric(6, 4), default=1, nullable=False, server_default="1")
    remarque = Column(String(255), nullable=True)


class PiemmeEnveloppe(Base):
    __tablename__ = "piemme_enveloppe"

    id = Column(Integer, primary_key=True, index=True)
    nom = Column(String(200), nullable=False)
    montant = Column(Numeric(10, 2), default=0, nullable=False)
    montant1 = Column(Numeric(10, 2), default=0, nullable=True)
    montant2 = Column(Numeric(10, 2), default=0, nullable=True)
    montant3 = Column(Numeric(10, 2), default=0, nullable=True)
    montant4 = Column(Numeric(10, 2), default=0, nullable=True)
    date_creation = Column(Date, nullable=True)
    remarque = Column(String(255), nullable=True)


class PiemmeFactureRetard(Base):
    __tablename__ = "piemme_facture_retard"

    id = Column(Integer, primary_key=True, index=True)
    date = Column(Date, nullable=False, index=True)
    montant = Column(Numeric(10, 2), default=0, nullable=False)
    fournisseur = Column(String(200), nullable=True)
    remarque = Column(String(255), nullable=True)
    date_echeance = Column(Date, nullable=True)
