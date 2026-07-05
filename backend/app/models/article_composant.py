from sqlalchemy import Column, Integer, String, Numeric, ForeignKey
from app.database import Base

class ArticleComposant(Base):
    """
    Une ligne de la "recette" d'un article (plat) : une description libre
    (ex: "5 scampis", "2 louches de sauce") et son prix déjà calculé pour la
    quantité utilisée dans CE plat (pas un prix unitaire à multiplier — la
    quantité est incluse dans la description, comme dans l'ancien système
    Access). Le coût matière d'un plat = somme de toutes ses lignes.
    Les articles sans aucune ligne ici (ex: boissons simples) utilisent
    directement Article.prix_achat comme coût.
    """
    __tablename__ = 'article_composants'
    id          = Column(Integer, primary_key=True, index=True)
    article_id  = Column(Integer, ForeignKey('articles.id'), nullable=False, index=True)
    description = Column(String(150), nullable=False)
    prix        = Column(Numeric(10, 2), nullable=False, default=0)