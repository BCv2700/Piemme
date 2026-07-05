from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date, datetime, timedelta
from typing import Optional
from app.database import get_db
from app.models.encaissement import Encaissement
from app.models.encaissement_ligne import EncaissementLigne
from app.models.commande import Commande
from app.models.table import Table
from app.schemas.encaissement import (
    EncaissementOut,
    EncaissementCreate,
    EncaissementUpdate,
    EncaissementLigneOut,
    EncaissementLigneCreate,
    EncaissementLigneUpdate,
)
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/encaissements", tags=["Encaissements"])


@router.get("/", response_model=list[EncaissementOut])
def list_encaissements(
    date_debut: Optional[date] = None,
    date_fin: Optional[date] = None,
    client_id: Optional[int] = None,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    query = db.query(Encaissement)
    if date_debut:
        query = query.filter(Encaissement.date_encaissement >= date_debut)
    if date_fin:
        # date_fin désigne une journée entière : on inclut tout jusqu'à 23:59:59.999999
        # de ce jour, sinon une comparaison directe à la date (minuit) exclurait toute
        # vente faite après 00:00 le jour même.
        borne_fin = datetime.combine(date_fin, datetime.max.time())
        query = query.filter(Encaissement.date_encaissement <= borne_fin)
    if client_id is not None:
        query = query.filter(Encaissement.client_id == client_id)
    return query.order_by(Encaissement.date_encaissement.desc()).all()


@router.get("/{encaissement_id}", response_model=EncaissementOut)
def get_encaissement(encaissement_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    enc = db.query(Encaissement).filter(Encaissement.id == encaissement_id).first()
    if not enc:
        raise HTTPException(status_code=404, detail="Encaissement introuvable")
    return enc


@router.post("/", response_model=EncaissementOut)
def create_encaissement(payload: EncaissementCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Finalise le paiement d'une table : crée l'encaissement + ses lignes,
    puis vide le caddy (commandes) de la table et la repasse à 'libre'.

    Si payload.date_encaissement est fourni (ex: encodage en différé depuis une
    date différente d'aujourd'hui dans le plan de salle), on l'utilise. Sinon,
    on laisse le server_default de la colonne (= now()) s'appliquer.
    """
    data = payload.dict(exclude={"lignes"}, exclude_none=True)
    db_encaissement = Encaissement(**data)
    db.add(db_encaissement)
    db.flush()  # pour obtenir db_encaissement.id avant le commit

    for ligne in payload.lignes:
        db_ligne = EncaissementLigne(encaissement_id=db_encaissement.id, **ligne.dict())
        db.add(db_ligne)

    # Vide le caddy de la table concernée, si renseignée
    if payload.table_nom:
        table = db.query(Table).filter(Table.nom == payload.table_nom).first()
        if table:
            db.query(Commande).filter(Commande.table_id == table.id).delete()
            table.statut = 'libre'

    db.commit()
    db.refresh(db_encaissement)
    return db_encaissement


@router.patch("/{encaissement_id}", response_model=EncaissementOut)
def update_encaissement(encaissement_id: int, payload: EncaissementUpdate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Modifie les champs d'un encaissement (montants, date, table, remarque...),
    sans toucher aux lignes. Utiliser les endpoints /lignes pour le détail des articles.
    """
    db_encaissement = db.query(Encaissement).filter(Encaissement.id == encaissement_id).first()
    if not db_encaissement:
        raise HTTPException(status_code=404, detail="Encaissement introuvable")
    for key, value in payload.dict(exclude_unset=True).items():
        setattr(db_encaissement, key, value)
    db.commit()
    db.refresh(db_encaissement)
    return db_encaissement


@router.delete("/{encaissement_id}")
def delete_encaissement(encaissement_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Supprime un encaissement et toutes ses lignes (cascade défini sur le modèle).
    """
    db_encaissement = db.query(Encaissement).filter(Encaissement.id == encaissement_id).first()
    if not db_encaissement:
        raise HTTPException(status_code=404, detail="Encaissement introuvable")
    db.delete(db_encaissement)
    db.commit()
    return {"message": "Encaissement supprimé"}


@router.post("/{encaissement_id}/lignes", response_model=EncaissementLigneOut)
def add_ligne(encaissement_id: int, payload: EncaissementLigneCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Ajoute une ligne (article) à un encaissement existant.
    """
    db_encaissement = db.query(Encaissement).filter(Encaissement.id == encaissement_id).first()
    if not db_encaissement:
        raise HTTPException(status_code=404, detail="Encaissement introuvable")
    db_ligne = EncaissementLigne(encaissement_id=encaissement_id, **payload.dict())
    db.add(db_ligne)
    db.commit()
    db.refresh(db_ligne)
    return db_ligne


@router.patch("/lignes/{ligne_id}", response_model=EncaissementLigneOut)
def update_ligne(ligne_id: int, payload: EncaissementLigneUpdate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Modifie une ligne (article, quantité, prix, tva) sans toucher aux autres lignes
    ni au montant_total de l'encaissement parent.
    """
    db_ligne = db.query(EncaissementLigne).filter(EncaissementLigne.id == ligne_id).first()
    if not db_ligne:
        raise HTTPException(status_code=404, detail="Ligne introuvable")
    for key, value in payload.dict(exclude_unset=True).items():
        setattr(db_ligne, key, value)
    db.commit()
    db.refresh(db_ligne)
    return db_ligne


@router.delete("/lignes/{ligne_id}")
def delete_ligne(ligne_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Supprime une ligne individuelle d'un encaissement.
    """
    db_ligne = db.query(EncaissementLigne).filter(EncaissementLigne.id == ligne_id).first()
    if not db_ligne:
        raise HTTPException(status_code=404, detail="Ligne introuvable")
    db.delete(db_ligne)
    db.commit()
    return {"message": "Ligne supprimée"}