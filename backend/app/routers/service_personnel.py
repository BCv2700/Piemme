from datetime import date, datetime
from decimal import Decimal
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.service_personnel import ServicePersonnel
from app.models.encaissement import Encaissement
from app.models.encaissement_ligne import EncaissementLigne
from app.schemas.service_personnel import (
    ServicePersonnelOut,
    ServicePersonnelCreate,
    ServicePersonnelUpdate,
)
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/service-personnel", tags=["Service Personnel"])

# Nom de la table "Dépenses" tel qu'utilisé partout ailleurs dans l'app
# (Caddy.jsx, Paiement.jsx) pour repérer les encaissements de dépense.
TABLE_NOM_DEPENSES = "Dépenses"


def _creer_ou_maj_encaissement_depense(
    db: Session,
    service: ServicePersonnelCreate,
    encaissement_existant: Optional[Encaissement] = None,
) -> Encaissement:
    """
    Crée (ou met à jour) l'encaissement de dépense correspondant à une saisie
    de service personnel.

    Le montant sort TOUJOURS en dépense (comme un loyer ou un achat de
    nourriture) : il apparaît dans les encaissements du jour et dans le Récap
    Mensuel/PDF quel que soit le type de paiement. Seule la répartition
    change : montant_cash si payé cash (sortie réelle de caisse), sinon
    montant_carte si payé via un tiers (ex: virement, ne touche pas le cash
    réel) — même convention que les dépenses encodées manuellement dans
    l'écran Caddy. Dans les deux cas, cash_analyse (qui ne porte que sur les
    recettes) n'est jamais impacté.
    """
    montant_negatif = -abs(service.montant)
    cash = montant_negatif if service.type_paiement == 'cash' else Decimal('0')
    carte = montant_negatif if service.type_paiement == 'tiers' else Decimal('0')
    date_encaissement = datetime.combine(service.date_service, service.heure_fin)
    article_nom = "Service " + service.nom

    if encaissement_existant is None:
        enc = Encaissement(
            table_nom=TABLE_NOM_DEPENSES,
            montant_cash=cash,
            montant_carte=carte,
            montant_total=montant_negatif,
            depenses=True,
            date_encaissement=date_encaissement,
        )
        db.add(enc)
        db.flush()  # pour obtenir enc.id avant de créer la ligne
        ligne = EncaissementLigne(
            encaissement_id=enc.id,
            article_nom=article_nom,
            quantite=Decimal('-1'),
            prix_vente=service.montant,
            tva=Decimal('0'),
            vente_analysee=False,
        )
        db.add(ligne)
        return enc

    encaissement_existant.montant_cash = cash
    encaissement_existant.montant_carte = carte
    encaissement_existant.montant_total = montant_negatif
    encaissement_existant.date_encaissement = date_encaissement
    # Une saisie de personnel n'a qu'une seule ligne : on la retrouve et on la met à jour.
    if encaissement_existant.lignes:
        ligne = encaissement_existant.lignes[0]
        ligne.article_nom = article_nom
        ligne.prix_vente = service.montant
    return encaissement_existant


@router.get("/", response_model=list[ServicePersonnelOut])
def list_service_personnel(
    date_debut: Optional[date] = None,
    date_fin: Optional[date] = None,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    query = db.query(ServicePersonnel)
    if date_debut:
        query = query.filter(ServicePersonnel.date_service >= date_debut)
    if date_fin:
        query = query.filter(ServicePersonnel.date_service <= date_fin)
    return query.order_by(ServicePersonnel.date_service.desc(), ServicePersonnel.heure_debut).all()


@router.get("/{service_id}", response_model=ServicePersonnelOut)
def get_service_personnel(
    service_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)
):
    service = db.query(ServicePersonnel).filter(ServicePersonnel.id == service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Service introuvable")
    return service


@router.get("/by-encaissement/{encaissement_id}", response_model=ServicePersonnelOut)
def get_service_personnel_par_encaissement(
    encaissement_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)
):
    """
    Retrouve la saisie de service personnel liée à un encaissement de dépense
    donné. Utilisé par l'écran Encaissements pour rediriger vers l'écran
    Personnel (plutôt que la fenêtre de détail générique) quand la ligne
    cliquée provient d'une saisie de service.
    """
    service = db.query(ServicePersonnel).filter(ServicePersonnel.encaissement_id == encaissement_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Aucun service personnel lié à cet encaissement")
    return service


@router.post("/", response_model=ServicePersonnelOut)
def create_service_personnel(
    payload: ServicePersonnelCreate, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)
):
    """
    Crée une saisie de service personnel ET, automatiquement, la dépense
    correspondante dans les encaissements du jour (voir
    _creer_ou_maj_encaissement_depense).
    """
    if payload.type_paiement not in ('cash', 'tiers'):
        raise HTTPException(status_code=422, detail="type_paiement doit être 'cash' ou 'tiers'")

    enc = _creer_ou_maj_encaissement_depense(db, payload)
    db_service = ServicePersonnel(
        nom=payload.nom,
        date_service=payload.date_service,
        heure_debut=payload.heure_debut,
        heure_fin=payload.heure_fin,
        taux_horaire=payload.taux_horaire,
        montant=payload.montant,
        type_paiement=payload.type_paiement,
        remarque=payload.remarque,
        encaissement_id=enc.id,
    )
    db.add(db_service)
    db.commit()
    db.refresh(db_service)
    return db_service


@router.patch("/{service_id}", response_model=ServicePersonnelOut)
def update_service_personnel(
    service_id: int,
    payload: ServicePersonnelUpdate,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    """
    Modifie une saisie de service personnel et répercute automatiquement les
    changements (montant, type de paiement, date, heures) sur l'encaissement
    de dépense lié, pour qu'ils restent toujours cohérents.
    """
    db_service = db.query(ServicePersonnel).filter(ServicePersonnel.id == service_id).first()
    if not db_service:
        raise HTTPException(status_code=404, detail="Service introuvable")

    updates = payload.dict(exclude_unset=True)
    if 'type_paiement' in updates and updates['type_paiement'] not in ('cash', 'tiers'):
        raise HTTPException(status_code=422, detail="type_paiement doit être 'cash' ou 'tiers'")

    for key, value in updates.items():
        setattr(db_service, key, value)

    enc = db.query(Encaissement).filter(Encaissement.id == db_service.encaissement_id).first()
    if enc:
        service_complet = ServicePersonnelCreate(
            nom=db_service.nom,
            date_service=db_service.date_service,
            heure_debut=db_service.heure_debut,
            heure_fin=db_service.heure_fin,
            taux_horaire=db_service.taux_horaire,
            montant=db_service.montant,
            type_paiement=db_service.type_paiement,
            remarque=db_service.remarque,
        )
        _creer_ou_maj_encaissement_depense(db, service_complet, encaissement_existant=enc)

    db.commit()
    db.refresh(db_service)
    return db_service


@router.delete("/{service_id}")
def delete_service_personnel(
    service_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)
):
    """
    Supprime une saisie de service personnel ET son encaissement de dépense
    lié (donc sa ligne aussi, via la cascade déjà définie sur Encaissement).
    """
    db_service = db.query(ServicePersonnel).filter(ServicePersonnel.id == service_id).first()
    if not db_service:
        raise HTTPException(status_code=404, detail="Service introuvable")
    enc = db.query(Encaissement).filter(Encaissement.id == db_service.encaissement_id).first()
    if enc:
        db.delete(enc)  # cascade : supprime la ligne, et via ON DELETE CASCADE, cette entrée service_personnel
    else:
        db.delete(db_service)
    db.commit()
    return {"message": "Service supprimé"}