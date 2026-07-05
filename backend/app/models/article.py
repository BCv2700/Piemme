from sqlalchemy import Column, Integer, String, Boolean, Numeric
from app.database import Base

class Article(Base):
    __tablename__ = 'articles'
    id               = Column(Integer, primary_key=True, index=True)
    nom              = Column(String(100), nullable=False)
    categorie        = Column(String(50))
    type_article     = Column(String(50))
    code_vente       = Column(Integer)
    tva              = Column(Numeric(5,2), default=21)
    tva_away         = Column(Numeric(5,2))
    prix_achat       = Column(Numeric(10,2), default=0)
    prix_vente       = Column(Numeric(10,2), nullable=False, default=0)
    prix_vente_away  = Column(Numeric(10,2))
    stock            = Column(Integer, default=0)
    stock_min        = Column(Integer, default=0)
    stock_max        = Column(Integer, default=0)
    stock_a_suivre   = Column(Boolean, default=False)
    est_boisson      = Column(Boolean, default=False)
    ean              = Column(String(20))
    fournisseur      = Column(String(100))
    localisation     = Column(String(100))
    actif            = Column(Boolean, default=True)
    # Distingue les articles de vente classiques ('vente') des articles utilisés
    # uniquement sur la table fictive DÉPENSES pour encoder des sorties de caisse
    # ('depense'). Filtré côté Caddy selon le type de la table active.
    type             = Column(String(20), nullable=False, default='vente')
    # Si True, cet article doit apparaître sur le ticket cuisine imprimé depuis
    # le Caddy (plats à préparer). Les boissons et autres articles sans
    # préparation cuisine restent à False.
    imprimer_cuisine = Column(Boolean, default=False)
    # Ordre d'affichage manuel des boutons articles dans le Caddy (équivalent
    # du champ A_Ordre de l'ancienne base Access). Nullable : les articles
    # sans ordre défini sont affichés après ceux qui en ont un, triés par nom.
    ordre            = Column(Integer, nullable=True)