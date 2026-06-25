from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.models.article import Article
from app.schemas.article import ArticleOut, ArticleCreate, ArticleUpdate
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/articles", tags=["Articles"])

@router.get("/", response_model=list[ArticleOut])
def list_articles(
    categorie: Optional[str] = None,
    actif: Optional[bool] = None,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    query = db.query(Article)
    if categorie:
        query = query.filter(Article.categorie == categorie)
    if actif is not None:
        query = query.filter(Article.actif == actif)
    return query.order_by(Article.nom).all()

@router.get("/{article_id}", response_model=ArticleOut)
def get_article(article_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    article = db.query(Article).filter(Article.id == article_id).first()
    if not article:
        raise HTTPException(status_code=404, detail="Article introuvable")
    return article

@router.post("/", response_model=ArticleOut)
def create_article(article: ArticleCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_article = Article(**article.dict())
    db.add(db_article)
    db.commit()
    db.refresh(db_article)
    return db_article

@router.patch("/{article_id}", response_model=ArticleOut)
def update_article(article_id: int, article: ArticleUpdate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_article = db.query(Article).filter(Article.id == article_id).first()
    if not db_article:
        raise HTTPException(status_code=404, detail="Article introuvable")
    for key, value in article.dict(exclude_unset=True).items():
        setattr(db_article, key, value)
    db.commit()
    db.refresh(db_article)
    return db_article

@router.delete("/{article_id}")
def delete_article(article_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    db_article = db.query(Article).filter(Article.id == article_id).first()
    if not db_article:
        raise HTTPException(status_code=404, detail="Article introuvable")
    db.delete(db_article)
    db.commit()
    return {"message": "Article supprimé"}