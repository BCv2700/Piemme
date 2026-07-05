from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.models.article_composant import ArticleComposant
from app.schemas.article_composant import (
    ArticleComposantOut,
    ArticleComposantCreate,
    ArticleComposantUpdate,
)
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/articles-composants", tags=["ArticlesComposants"])


@router.get("/", response_model=list[ArticleComposantOut])
def list_composants(
    article_id: Optional[int] = None,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    """
    Sans paramètre : renvoie TOUTES les lignes de composants (utilisé par le
    rapport de coût matière, qui a besoin de tout charger d'un coup pour
    calculer le coût de chaque ligne vendue sans faire une requête par plat).
    Avec article_id : renvoie uniquement les lignes de ce plat (utilisé par
    la fiche article).
    """
    query = db.query(ArticleComposant)
    if article_id is not None:
        query = query.filter(ArticleComposant.article_id == article_id)
    return query.order_by(ArticleComposant.article_id, ArticleComposant.id).all()


@router.post("/", response_model=ArticleComposantOut)
def create_composant(payload: ArticleComposantCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_composant = ArticleComposant(**payload.dict())
    db.add(db_composant)
    db.commit()
    db.refresh(db_composant)
    return db_composant


@router.patch("/{composant_id}", response_model=ArticleComposantOut)
def update_composant(composant_id: int, payload: ArticleComposantUpdate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_composant = db.query(ArticleComposant).filter(ArticleComposant.id == composant_id).first()
    if not db_composant:
        raise HTTPException(status_code=404, detail="Composant introuvable")
    for key, value in payload.dict(exclude_unset=True).items():
        setattr(db_composant, key, value)
    db.commit()
    db.refresh(db_composant)
    return db_composant


@router.delete("/{composant_id}")
def delete_composant(composant_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_composant = db.query(ArticleComposant).filter(ArticleComposant.id == composant_id).first()
    if not db_composant:
        raise HTTPException(status_code=404, detail="Composant introuvable")
    db.delete(db_composant)
    db.commit()
    return {"message": "Composant supprimé"}