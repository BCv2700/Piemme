from sqlalchemy import Column, Integer, String, Boolean, Numeric, Date
from app.database import Base

class ArticleAchat(Base):
    """
    Liste des articles à acheter chez les fournisseurs (équivalent de l'ancienne
    table Access T_Achats_a_Faire). Totalement indépendante de la table Article
    (qui concerne les articles VENDUS aux clients) : celle-ci contient aussi bien
    des denrées que des fournitures diverses (ballons, bougies, bacs...).
    """
    __tablename__ = 'articles_achat'
    id                     = Column(Integer, primary_key=True, index=True)
    nom                    = Column(String(150), nullable=False)
    qte                    = Column(Integer, default=0)
    prix_achat             = Column(Numeric(10, 2), nullable=True)
    magasin                = Column(String(100), nullable=True)
    # Coché = à inclure dans la prochaine commande (impression / email)
    a_commander            = Column(Boolean, default=False)
    # Date de la dernière commande de cet article, informative uniquement.
    # Non mise à jour automatiquement : c'est l'utilisateur qui gère.
    date_derniere_commande = Column(Date, nullable=True)