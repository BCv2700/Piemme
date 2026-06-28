from sqlalchemy import Column, Integer, Numeric, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import JSONB
from app.database import Base


class RecapMensuel(Base):
    __tablename__ = 'recap_mensuel'

    id          = Column(Integer, primary_key=True, index=True)
    annee       = Column(Integer, nullable=False)
    mois        = Column(Integer, nullable=False)
    # Champ mémo libre du mois (annotations « Nettoyage », justifications de km...)
    memo        = Column(Text, default='')
    # Valeur de km par défaut appliquée à chaque jour, modifiable (ex. déménagement)
    km_defaut   = Column(Numeric(10, 2), default=53.4)
    # Exceptions de km : dictionnaire { "jour_du_mois": montant }, ex. {"4": 0, "11": 0}
    # Tout jour absent du dictionnaire utilise km_defaut.
    km_par_jour = Column(JSONB, default=dict)
    # Jours marqués comme "Fermé" (étiquette visuelle uniquement, pas de calcul) :
    # dictionnaire { "jour_du_mois": true/false }. Jour absent = pas fermé.
    ferme_par_jour = Column(JSONB, default=dict)

    __table_args__ = (
        UniqueConstraint('annee', 'mois', name='uq_recap_annee_mois'),
    )