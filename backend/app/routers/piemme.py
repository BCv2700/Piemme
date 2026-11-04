from fastapi import APIRouter, Depends, HTTPException, Header, Request
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from sqlalchemy import text, extract
from decimal import Decimal
from datetime import date, datetime
import calendar
import os

from app.database import get_db
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur
from app.models.piemme import PiemmeJour, PiemmeDepenseRecurrente, PiemmeConfig, PiemmeDepenseDetail, PiemmeFactureRetard, PiemmeEnveloppe
from app.services.email_service import envoyer_mail_recette, envoyer_mail_facture, envoyer_mail_recette_manquante, envoyer_mail_echeances_depassees, envoyer_mail_recurrentes_dues

router = APIRouter(prefix="/piemme", tags=["Piemme"], dependencies=[Depends(get_current_user)])

# Router séparé pour les crons : pas de JWT, vérification par X-Cron-Secret en interne
cron_router = APIRouter(prefix="/piemme", tags=["Piemme Crons"])

TVA_PCT = Decimal("21")
NB_JOURS_ENVELOPPE = 20


# ── Jours : CRUD ─────────────────────────────────────────────

@router.get("/mois/{annee}/{mois}")
def get_mois(annee: int, mois: int, db: Session = Depends(get_db)):
    jours = (
        db.query(PiemmeJour)
        .filter(extract("year", PiemmeJour.date) == annee)
        .filter(extract("month", PiemmeJour.date) == mois)
        .order_by(PiemmeJour.date)
        .all()
    )
    config = db.query(PiemmeConfig).filter(
        PiemmeConfig.annee == annee, PiemmeConfig.mois == mois
    ).first()
    pct_eco = float(config.pct_economie) if config else 15.0
    recurrentes = db.query(PiemmeDepenseRecurrente).filter(PiemmeDepenseRecurrente.actif == True).all()
    total_recurrentes = sum(float(r.montant) for r in recurrentes)
    details = (
        db.query(PiemmeDepenseDetail)
        .filter(extract("year", PiemmeDepenseDetail.date) == annee)
        .filter(extract("month", PiemmeDepenseDetail.date) == mois)
        .order_by(PiemmeDepenseDetail.date, PiemmeDepenseDetail.id)
        .all()
    )
    total_recettes = sum(float(j.recette) for j in jours)
    total_depenses = sum(float(j.depense) for j in jours)
    total_tva = round(total_recettes * 21 / 100, 2)
    benefice = round(total_recettes - total_depenses - total_tva, 2)
    env_depenses = round(total_depenses / NB_JOURS_ENVELOPPE, 2) if total_depenses else 0
    env_tva = total_tva
    env_economie = round(total_recettes * pct_eco / 100, 2)
    env_recurrentes = round(total_recurrentes / NB_JOURS_ENVELOPPE, 2) if total_recurrentes else 0
    nb_jours_mois = calendar.monthrange(annee, mois)[1]
    return {
        "annee": annee, "mois": mois, "nb_jours": nb_jours_mois, "pct_economie": pct_eco,
        "jours": [{"id": j.id, "date": str(j.date), "jour": j.date.day, "recette": float(j.recette),
                   "depense": float(j.depense), "remarque": j.remarque,
                   "tva": round(float(j.recette) * 21 / 100, 2),
                   "economie": round(float(j.recette) * pct_eco / 100, 2)} for j in jours],
        "resume": {"total_recettes": total_recettes, "total_depenses": total_depenses,
                   "total_tva": total_tva, "benefice": benefice},
        "enveloppes": {"depenses": env_depenses, "tva": env_tva, "economie": env_economie,
                       "recurrentes": env_recurrentes, "total_recurrentes": total_recurrentes},
        "depense_details": [{"id": d.id, "date": str(d.date), "jour": d.date.day,
                             "montant": float(d.montant), "libelle": d.libelle, "paye": d.paye,
                             "coefficient": float(d.coefficient) if d.coefficient is not None else 1.0,
                             "remarque": d.remarque} for d in details],
    }


@router.post("/jour")
def upsert_jour(payload: dict, db: Session = Depends(get_db)):
    date_str = payload.get("date")
    if not date_str:
        raise HTTPException(400, "Date requise")
    try:
        d = datetime.strptime(date_str, "%Y-%m-%d").date()
    except ValueError:
        raise HTTPException(400, "Format date: YYYY-MM-DD")
    jour = db.query(PiemmeJour).filter(PiemmeJour.date == d).first()
    if jour:
        if "recette" in payload: jour.recette = payload["recette"]
        if "depense" in payload: jour.depense = payload["depense"]
        if "remarque" in payload: jour.remarque = payload["remarque"]
    else:
        jour = PiemmeJour(date=d, recette=payload.get("recette", 0),
                          depense=payload.get("depense", 0), remarque=payload.get("remarque"))
        db.add(jour)
    db.commit()
    db.refresh(jour)
    if "recette" in payload and float(payload["recette"]) > 0:
        try:
            envoyer_mail_recette(date_str=str(jour.date), montant=float(jour.recette), remarque=jour.remarque)
        except Exception as e:
            import logging; logging.getLogger(__name__).error(f"[PIEMME] Erreur mail recette: {e}")
    return {"id": jour.id, "date": str(jour.date), "recette": float(jour.recette),
            "depense": float(jour.depense), "remarque": jour.remarque}


@router.delete("/jour/{jour_id}")
def supprimer_jour(jour_id: int, db: Session = Depends(get_db)):
    jour = db.query(PiemmeJour).filter(PiemmeJour.id == jour_id).first()
    if not jour: raise HTTPException(404, "Jour introuvable")
    db.delete(jour); db.commit()
    return {"ok": True}


# ── Config % économie ─────────────────────────────────────────

@router.post("/config")
def set_config(payload: dict, db: Session = Depends(get_db)):
    annee = payload.get("annee"); mois = payload.get("mois"); pct = payload.get("pct_economie", 15)
    if not annee or not mois: raise HTTPException(400, "Année et mois requis")
    config = db.query(PiemmeConfig).filter(PiemmeConfig.annee == annee, PiemmeConfig.mois == mois).first()
    if config: config.pct_economie = pct
    else: config = PiemmeConfig(annee=annee, mois=mois, pct_economie=pct); db.add(config)
    db.commit()
    return {"ok": True, "pct_economie": float(pct)}


# ── Détails dépenses ──────────────────────────────────────────

def _recalculer_depense_jour(db: Session, d: date):
    from sqlalchemy import func as sqlfunc
    total = float(db.query(sqlfunc.coalesce(sqlfunc.sum(PiemmeDepenseDetail.montant), 0))
                  .filter(PiemmeDepenseDetail.date == d).scalar())
    jour = db.query(PiemmeJour).filter(PiemmeJour.date == d).first()
    if jour: jour.depense = total
    elif total > 0: jour = PiemmeJour(date=d, recette=0, depense=total); db.add(jour)
    db.commit()


@router.post("/depense-detail")
def ajouter_depense_detail(payload: dict, db: Session = Depends(get_db)):
    date_str = payload.get("date")
    if not date_str: raise HTTPException(400, "Date requise")
    try: d = datetime.strptime(date_str, "%Y-%m-%d").date()
    except ValueError: raise HTTPException(400, "Format date: YYYY-MM-DD")
    montant = payload.get("montant", 0)
    if not montant or float(montant) <= 0: raise HTTPException(400, "Montant requis et > 0")
    detail = PiemmeDepenseDetail(date=d, montant=montant,
                                 libelle=(payload.get("libelle") or "").strip() or None,
                                 paye=False, remarque=(payload.get("remarque") or "").strip() or None)
    db.add(detail); db.commit(); db.refresh(detail)
    _recalculer_depense_jour(db, d)
    return {"id": detail.id, "date": str(detail.date), "jour": detail.date.day,
            "montant": float(detail.montant), "libelle": detail.libelle, "paye": detail.paye,
            "remarque": detail.remarque}


@router.delete("/depense-detail/{detail_id}")
def supprimer_depense_detail(detail_id: int, db: Session = Depends(get_db)):
    detail = db.query(PiemmeDepenseDetail).filter(PiemmeDepenseDetail.id == detail_id).first()
    if not detail: raise HTTPException(404, "Détail introuvable")
    d = detail.date; db.delete(detail); db.commit()
    _recalculer_depense_jour(db, d)
    return {"ok": True}


@router.post("/depense-detail/{detail_id}/modifier")
def modifier_depense_detail(detail_id: int, payload: dict, db: Session = Depends(get_db)):
    detail = db.query(PiemmeDepenseDetail).filter(PiemmeDepenseDetail.id == detail_id).first()
    if not detail: raise HTTPException(404, "Détail introuvable")
    ancienne_date = detail.date
    if "date" in payload:
        try: detail.date = datetime.strptime(payload["date"], "%Y-%m-%d").date()
        except ValueError: raise HTTPException(400, "Format date: YYYY-MM-DD")
    if "montant" in payload: detail.montant = payload["montant"]
    if "libelle" in payload: detail.libelle = (payload["libelle"] or "").strip() or None
    if "paye" in payload: detail.paye = bool(payload["paye"])
    if "remarque" in payload: detail.remarque = (payload["remarque"] or "").strip() or None
    if "coefficient" in payload: detail.coefficient = max(0.01, float(payload["coefficient"]))
    db.commit(); db.refresh(detail)
    _recalculer_depense_jour(db, ancienne_date)
    if detail.date != ancienne_date: _recalculer_depense_jour(db, detail.date)
    return {"id": detail.id, "date": str(detail.date), "jour": detail.date.day,
            "montant": float(detail.montant), "libelle": detail.libelle, "paye": detail.paye,
            "coefficient": float(detail.coefficient) if detail.coefficient is not None else 1.0,
            "remarque": detail.remarque}


# ── Factures en retard ────────────────────────────────────────

def _fmt_facture(f):
    return {"id": f.id, "date": str(f.date), "montant": float(f.montant),
            "fournisseur": f.fournisseur, "remarque": f.remarque,
            "date_echeance": str(f.date_echeance) if f.date_echeance else None}


@router.get("/factures-en-retard")
def get_factures_en_retard(db: Session = Depends(get_db)):
    return [_fmt_facture(f) for f in db.query(PiemmeFactureRetard)
            .order_by(PiemmeFactureRetard.date, PiemmeFactureRetard.id).all()]


@router.post("/factures-en-retard")
def ajouter_facture_retard(payload: dict, db: Session = Depends(get_db)):
    date_str = payload.get("date")
    if not date_str: raise HTTPException(400, "Date requise")
    try: d = datetime.strptime(date_str, "%Y-%m-%d").date()
    except ValueError: raise HTTPException(400, "Format date: YYYY-MM-DD")
    montant = payload.get("montant", 0)
    if not montant or float(montant) <= 0: raise HTTPException(400, "Montant requis et > 0")
    date_echeance = None
    if payload.get("date_echeance"):
        try: date_echeance = datetime.strptime(payload["date_echeance"], "%Y-%m-%d").date()
        except ValueError: pass
    f = PiemmeFactureRetard(date=d, montant=montant,
                            fournisseur=(payload.get("fournisseur") or "").strip() or None,
                            remarque=(payload.get("remarque") or "").strip() or None,
                            date_echeance=date_echeance)
    db.add(f); db.commit(); db.refresh(f)
    try: envoyer_mail_facture(date_str=str(f.date), montant=float(f.montant),
                              fournisseur=f.fournisseur, remarque=f.remarque)
    except Exception as e:
        import logging; logging.getLogger(__name__).error(f"[PIEMME] Erreur mail facture: {e}")
    return _fmt_facture(f)


@router.post("/factures-en-retard/{facture_id}/modifier")
def modifier_facture_retard(facture_id: int, payload: dict, db: Session = Depends(get_db)):
    f = db.query(PiemmeFactureRetard).filter(PiemmeFactureRetard.id == facture_id).first()
    if not f: raise HTTPException(404, "Facture introuvable")
    if "date" in payload:
        try: f.date = datetime.strptime(payload["date"], "%Y-%m-%d").date()
        except ValueError: raise HTTPException(400, "Format date: YYYY-MM-DD")
    if "montant" in payload: f.montant = payload["montant"]
    if "fournisseur" in payload: f.fournisseur = (payload["fournisseur"] or "").strip() or None
    if "remarque" in payload: f.remarque = (payload["remarque"] or "").strip() or None
    if "date_echeance" in payload:
        if payload["date_echeance"]:
            try: f.date_echeance = datetime.strptime(payload["date_echeance"], "%Y-%m-%d").date()
            except ValueError: pass
        else: f.date_echeance = None
    db.commit(); db.refresh(f)
    return _fmt_facture(f)


@router.post("/factures-en-retard/{facture_id}/payer")
def payer_facture_retard(facture_id: int, payload: dict = {}, db: Session = Depends(get_db)):
    f = db.query(PiemmeFactureRetard).filter(PiemmeFactureRetard.id == facture_id).first()
    if not f: raise HTTPException(404, "Facture introuvable")
    date_paiement_str = payload.get("date_paiement") if payload else None
    if date_paiement_str:
        try: date_paiement = datetime.strptime(date_paiement_str, "%Y-%m-%d").date()
        except ValueError: raise HTTPException(400, "Format date: YYYY-MM-DD")
    else: date_paiement = date.today()
    libelle_parts = []
    if f.fournisseur: libelle_parts.append(f.fournisseur)
    if f.remarque: libelle_parts.append(f.remarque)
    libelle = " — ".join(libelle_parts) if libelle_parts else "Facture payée"
    detail = PiemmeDepenseDetail(date=date_paiement, montant=f.montant, libelle=libelle, paye=True)
    db.add(detail); db.flush(); db.delete(f); db.commit()
    _recalculer_depense_jour(db, date_paiement)
    return {"ok": True, "depense_detail_id": detail.id, "date_paiement": str(date_paiement),
            "montant": float(detail.montant), "libelle": detail.libelle}


@router.delete("/factures-en-retard/{facture_id}")
def supprimer_facture_retard(facture_id: int, db: Session = Depends(get_db)):
    f = db.query(PiemmeFactureRetard).filter(PiemmeFactureRetard.id == facture_id).first()
    if not f: raise HTTPException(404, "Facture introuvable")
    db.delete(f); db.commit()
    return {"ok": True}


# ── Dépenses récurrentes ──────────────────────────────────────

def _fmt_recurrente(i):
    return {"id": i.id, "libelle": i.libelle, "montant": float(i.montant), "actif": i.actif,
            "date_echeance": str(i.date_echeance) if i.date_echeance else None,
            "jour_du_mois": i.jour_du_mois, "email_envoye_mois": i.email_envoye_mois}


@router.get("/depenses-recurrentes")
def list_recurrentes(db: Session = Depends(get_db)):
    return [_fmt_recurrente(i) for i in db.query(PiemmeDepenseRecurrente)
            .order_by(PiemmeDepenseRecurrente.libelle).all()]


@router.post("/depenses-recurrentes")
def ajouter_recurrente(payload: dict, db: Session = Depends(get_db)):
    libelle = (payload.get("libelle") or "").strip()
    if not libelle: raise HTTPException(400, "Libellé requis")
    date_echeance = None
    if payload.get("date_echeance"):
        try: date_echeance = datetime.strptime(payload["date_echeance"], "%Y-%m-%d").date()
        except ValueError: pass
    jour_du_mois = int(payload["jour_du_mois"]) if payload.get("jour_du_mois") is not None else None
    item = PiemmeDepenseRecurrente(libelle=libelle, montant=payload.get("montant", 0),
                                   actif=True, date_echeance=date_echeance, jour_du_mois=jour_du_mois)
    db.add(item); db.commit(); db.refresh(item)
    return _fmt_recurrente(item)


@router.patch("/depenses-recurrentes/{item_id}")
def modifier_recurrente(item_id: int, payload: dict, db: Session = Depends(get_db)):
    item = db.query(PiemmeDepenseRecurrente).filter(PiemmeDepenseRecurrente.id == item_id).first()
    if not item: raise HTTPException(404, "Introuvable")
    if "libelle" in payload: item.libelle = payload["libelle"]
    if "montant" in payload: item.montant = payload["montant"]
    if "actif" in payload: item.actif = bool(payload["actif"])
    if "date_echeance" in payload:
        if payload["date_echeance"]:
            try: item.date_echeance = datetime.strptime(payload["date_echeance"], "%Y-%m-%d").date()
            except ValueError: pass
        else: item.date_echeance = None
    if "jour_du_mois" in payload:
        item.jour_du_mois = int(payload["jour_du_mois"]) if payload["jour_du_mois"] is not None else None
    if "email_envoye_mois" in payload: item.email_envoye_mois = payload["email_envoye_mois"]
    db.commit()
    return _fmt_recurrente(item)


@router.patch("/depenses-recurrentes/{item_id}/toggle-email")
def toggle_email_recurrente(item_id: int, db: Session = Depends(get_db)):
    from datetime import date as date_type
    item = db.query(PiemmeDepenseRecurrente).filter(PiemmeDepenseRecurrente.id == item_id).first()
    if not item: raise HTTPException(404, "Introuvable")
    mois_actuel = date_type.today().strftime("%Y-%m")
    item.email_envoye_mois = None if item.email_envoye_mois == mois_actuel else mois_actuel
    db.commit()
    return _fmt_recurrente(item)


@router.delete("/depenses-recurrentes/{item_id}")
def supprimer_recurrente(item_id: int, db: Session = Depends(get_db)):
    item = db.query(PiemmeDepenseRecurrente).filter(PiemmeDepenseRecurrente.id == item_id).first()
    if not item: raise HTTPException(404, "Introuvable")
    db.delete(item); db.commit()
    return {"ok": True}


# ── Vue annuelle ──────────────────────────────────────────────

@router.get("/annuel/{annee}")
def get_annuel(annee: int, db: Session = Depends(get_db)):
    jours = (db.query(PiemmeJour).filter(extract("year", PiemmeJour.date) == annee)
             .order_by(PiemmeJour.date).all())
    mois_data = {}
    for j in jours:
        m = j.date.month
        if m not in mois_data: mois_data[m] = {"jours": {}, "total_recettes": 0, "total_depenses": 0}
        mois_data[m]["jours"][j.date.day] = {"recette": float(j.recette), "depense": float(j.depense)}
        mois_data[m]["total_recettes"] += float(j.recette)
        mois_data[m]["total_depenses"] += float(j.depense)
    for m in mois_data:
        d = mois_data[m]
        d["total_tva"] = round(d["total_recettes"] * 21 / 100, 2)
        d["benefice"] = round(d["total_recettes"] - d["total_depenses"] - d["total_tva"], 2)
    total_rec = sum(d["total_recettes"] for d in mois_data.values())
    total_dep = sum(d["total_depenses"] for d in mois_data.values())
    total_tva = round(total_rec * 21 / 100, 2)
    return {"annee": annee, "mois": mois_data,
            "totaux": {"recettes": total_rec, "depenses": total_dep, "tva": total_tva,
                       "benefice": round(total_rec - total_dep - total_tva, 2)}}


# ── Enveloppes ────────────────────────────────────────────────

def _fmt_enveloppe(i):
    m1,m2,m3,m4 = float(i.montant1 or 0),float(i.montant2 or 0),float(i.montant3 or 0),float(i.montant4 or 0)
    return {"id": i.id, "nom": i.nom, "montant": round(m1+m2+m3+m4,2),
            "montant1": m1, "montant2": m2, "montant3": m3, "montant4": m4,
            "date_creation": str(i.date_creation) if i.date_creation else None, "remarque": i.remarque}


@router.get("/enveloppes")
def list_enveloppes(db: Session = Depends(get_db)):
    return [_fmt_enveloppe(i) for i in db.query(PiemmeEnveloppe).order_by(PiemmeEnveloppe.nom).all()]


@router.post("/enveloppes")
def ajouter_enveloppe(payload: dict, db: Session = Depends(get_db)):
    from datetime import date as date_type
    nom = (payload.get("nom") or "").strip()
    if not nom: raise HTTPException(400, "Nom requis")
    m1,m2,m3,m4 = (float(payload.get(f"montant{i}", 0) or 0) for i in range(1,5))
    dc = None
    if payload.get("date_creation"):
        try: dc = date_type.fromisoformat(str(payload["date_creation"]))
        except: pass
    item = PiemmeEnveloppe(nom=nom, montant=round(m1+m2+m3+m4,2), montant1=m1, montant2=m2,
                           montant3=m3, montant4=m4, date_creation=dc,
                           remarque=(payload.get("remarque") or "").strip() or None)
    db.add(item); db.commit(); db.refresh(item)
    return _fmt_enveloppe(item)


@router.patch("/enveloppes/{item_id}")
def modifier_enveloppe(item_id: int, payload: dict, db: Session = Depends(get_db)):
    from datetime import date as date_type
    item = db.query(PiemmeEnveloppe).filter(PiemmeEnveloppe.id == item_id).first()
    if not item: raise HTTPException(404, "Introuvable")
    if "nom" in payload: item.nom = (payload["nom"] or "").strip() or item.nom
    for champ in ("montant1","montant2","montant3","montant4"):
        if champ in payload: setattr(item, champ, float(payload[champ] or 0))
    item.montant = round(sum(float(getattr(item,f"montant{i}") or 0) for i in range(1,5)), 2)
    if "date_creation" in payload:
        if not payload["date_creation"]: item.date_creation = None
        else:
            try: item.date_creation = date_type.fromisoformat(str(payload["date_creation"]))
            except: pass
    if "remarque" in payload: item.remarque = (payload["remarque"] or "").strip() or None
    db.commit(); db.refresh(item)
    return _fmt_enveloppe(item)


@router.delete("/enveloppes/{item_id}")
def supprimer_enveloppe(item_id: int, db: Session = Depends(get_db)):
    item = db.query(PiemmeEnveloppe).filter(PiemmeEnveloppe.id == item_id).first()
    if not item: raise HTTPException(404, "Introuvable")
    db.delete(item); db.commit()
    return {"ok": True}


# ── Trimestre TVA ─────────────────────────────────────────────

@router.get("/trimestre/{annee}/{trimestre}")
def tva_trimestre(annee: int, trimestre: int, db: Session = Depends(get_db)):
    if trimestre not in (1,2,3,4): raise HTTPException(400, "Trimestre doit être 1, 2, 3 ou 4")
    mois_debut = (trimestre-1)*3+1; mois_fin = mois_debut+2
    mois_labels = {1:'Jan',2:'Fév',3:'Mar',4:'Avr',5:'Mai',6:'Jun',7:'Jul',8:'Aoû',9:'Sep',10:'Oct',11:'Nov',12:'Déc'}
    total_tva_payer = 0.0; total_tva_deja_payee = 0.0; mois_detail = []
    for m in range(mois_debut, mois_fin+1):
        details = db.query(PiemmeDepenseDetail).filter(
            extract('year', PiemmeDepenseDetail.date) == annee,
            extract('month', PiemmeDepenseDetail.date) == m).all()
        lignes = [d for d in details if (float(d.coefficient) if d.coefficient else 1.0) > 1]
        tva_payer = sum(float(d.montant)*(float(d.coefficient) if d.coefficient else 1.0)*0.21 for d in lignes)
        tva_payee = sum(float(d.montant)*0.21 for d in lignes)
        total_tva_payer += tva_payer; total_tva_deja_payee += tva_payee
        mois_detail.append({"mois": m, "label": mois_labels[m],
                            "tva_a_payer": round(tva_payer,2), "tva_deja_payee": round(tva_payee,2)})
    return {"annee": annee, "trimestre": trimestre, "mois_debut": mois_debut, "mois_fin": mois_fin,
            "total_tva_a_payer": round(total_tva_payer,2), "total_tva_deja_payee": round(total_tva_deja_payee,2),
            "solde_tva": round(total_tva_payer-total_tva_deja_payee,2), "mois": mois_detail}


# ── Crons ─────────────────────────────────────────────────────

@cron_router.get("/check-echeances-factures")
def check_echeances_factures(x_cron_secret: str = Header(default=None), db: Session = Depends(get_db)):
    cron_secret = os.getenv("CRON_SECRET", "")
    if not cron_secret or x_cron_secret != cron_secret:
        raise HTTPException(status_code=403, detail="Accès non autorisé")
    from datetime import date as date_type
    aujourd_hui = date_type.today()
    factures_depassees = (db.query(PiemmeFactureRetard)
        .filter(PiemmeFactureRetard.date_echeance != None,
                PiemmeFactureRetard.date_echeance < aujourd_hui)
        .order_by(PiemmeFactureRetard.date_echeance).all())
    if not factures_depassees:
        return {"ok": True, "echeances_depassees": False, "date": str(aujourd_hui)}
    liste = [{"id": f.id, "date": str(f.date), "montant": float(f.montant),
              "fournisseur": f.fournisseur, "remarque": f.remarque,
              "date_echeance": str(f.date_echeance), "aujourd_hui": str(aujourd_hui)}
             for f in factures_depassees]
    try: mail_envoye = envoyer_mail_echeances_depassees(liste)
    except Exception as e:
        import logging; logging.getLogger(__name__).error(f"[PIEMME] Erreur mail: {e}"); mail_envoye = False
    return {"ok": True, "echeances_depassees": True, "nb_factures": len(liste),
            "total": sum(f["montant"] for f in liste), "mail_envoye": mail_envoye}


@cron_router.get("/check-recurrentes-dues")
def check_recurrentes_dues(x_cron_secret: str = Header(default=None), db: Session = Depends(get_db)):
    cron_secret = os.getenv("CRON_SECRET", "")
    if not cron_secret or x_cron_secret != cron_secret:
        raise HTTPException(status_code=403, detail="Accès non autorisé")
    from datetime import date as date_type
    aujourd_hui = date_type.today()
    mois_actuel = aujourd_hui.strftime("%Y-%m")
    candidates = (db.query(PiemmeDepenseRecurrente)
        .filter(PiemmeDepenseRecurrente.actif == True,
                PiemmeDepenseRecurrente.jour_du_mois != None,
                PiemmeDepenseRecurrente.jour_du_mois <= aujourd_hui.day).all())
    a_notifier = [i for i in candidates if i.email_envoye_mois != mois_actuel]
    if not a_notifier:
        return {"ok": True, "recurrentes_dues": False, "mois": mois_actuel}
    liste = [{"id": i.id, "libelle": i.libelle, "montant": float(i.montant),
              "jour_du_mois": i.jour_du_mois, "mois_actuel": mois_actuel} for i in a_notifier]
    try: mail_envoye = envoyer_mail_recurrentes_dues(liste)
    except Exception as e:
        import logging; logging.getLogger(__name__).error(f"[PIEMME] Erreur mail: {e}"); mail_envoye = False
    if mail_envoye:
        for i in a_notifier: i.email_envoye_mois = mois_actuel
        db.commit()
    return {"ok": True, "recurrentes_dues": True, "mois": mois_actuel,
            "nb": len(a_notifier), "total": sum(i["montant"] for i in liste), "mail_envoye": mail_envoye}


@cron_router.get("/check-recette-du-jour")
def check_recette_du_jour(x_cron_secret: str = Header(default=None), db: Session = Depends(get_db)):
    cron_secret = os.getenv("CRON_SECRET", "")
    if not cron_secret or x_cron_secret != cron_secret:
        raise HTTPException(status_code=403, detail="Accès non autorisé")
    from datetime import date as date_type
    aujourd_hui = date_type.today()
    if aujourd_hui.weekday() >= 5:
        return {"ok": True, "weekend": True, "message": "Week-end — pas de vérification"}
    jour = db.query(PiemmeJour).filter(PiemmeJour.date == aujourd_hui).first()
    if jour and float(jour.recette) > 0:
        return {"ok": True, "recette_encodee": True, "date": str(aujourd_hui), "montant": float(jour.recette)}
    try: envoyer_mail_recette_manquante(date_str=str(aujourd_hui)); mail_envoye = True
    except Exception as e:
        import logging; logging.getLogger(__name__).error(f"[PIEMME] Erreur mail: {e}"); mail_envoye = False
    return {"ok": True, "recette_encodee": False, "date": str(aujourd_hui), "mail_envoye": mail_envoye}


# ── PDF mensuel et annuel ─────────────────────────────────────
# (identiques au router LOLIVE — copiés intégralement)

MOIS_NOM = ['','Janvier','Février','Mars','Avril','Mai','Juin',
            'Juillet','Août','Septembre','Octobre','Novembre','Décembre']


def _auth_token(token: str, db: Session, request: Request = None):
    from app.auth import lire_username_depuis_token
    bearer = None
    if request:
        auth_header = request.headers.get("Authorization","")
        if auth_header.startswith("Bearer "): bearer = auth_header[7:]
    token_effectif = bearer or token
    if not token_effectif: raise HTTPException(status_code=401, detail="Token requis")
    username = lire_username_depuis_token(token_effectif)
    if not username: raise HTTPException(status_code=401, detail="Token invalide")
    utilisateur = db.query(Utilisateur).filter(Utilisateur.username == username).first()
    if not utilisateur or not utilisateur.actif: raise HTTPException(status_code=401, detail="Utilisateur invalide")
    return utilisateur


@router.get("/mois/{annee}/{mois}/pdf", dependencies=[])
def pdf_mensuel(annee: int, mois: int, request: Request, token: str = None,
                inline: bool = False, db: Session = Depends(get_db)):
    _auth_token(token, db, request)
    import io
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.units import mm
    from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Spacer, Paragraph
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

    jours = (db.query(PiemmeJour)
             .filter(extract("year", PiemmeJour.date)==annee, extract("month", PiemmeJour.date)==mois)
             .order_by(PiemmeJour.date).all())
    config = db.query(PiemmeConfig).filter(PiemmeConfig.annee==annee, PiemmeConfig.mois==mois).first()
    pct_eco = float(config.pct_economie) if config else 15.0
    recurrentes = db.query(PiemmeDepenseRecurrente).filter(PiemmeDepenseRecurrente.actif==True).all()
    total_recurrentes = sum(float(r.montant) for r in recurrentes)
    details = (db.query(PiemmeDepenseDetail)
               .filter(extract("year", PiemmeDepenseDetail.date)==annee,
                       extract("month", PiemmeDepenseDetail.date)==mois)
               .order_by(PiemmeDepenseDetail.date, PiemmeDepenseDetail.id).all())
    jours_map = {j.date.day: j for j in jours}
    total_rec = sum(float(j.recette) for j in jours)
    total_dep = sum(float(j.depense) for j in jours)
    total_tva = round(total_rec*21/100, 2)
    benefice = round(total_rec-total_dep-total_tva, 2)
    total_details = sum(float(d.montant) for d in details)
    nb_jours = calendar.monthrange(annee, mois)[1]

    import datetime as dt_mod
    premier = dt_mod.date(annee, mois, 1)
    offset = premier.weekday()
    JOURS_SEM = ['L','M','M','J','V','S','D']
    weeks = []; week = [None]*7
    for d in range(1, nb_jours+1):
        pos = (offset+d-1)%7
        if d>1 and pos==0: weeks.append(week); week=[None]*7
        week[pos] = d
    weeks.append(week)

    buf = io.BytesIO()
    doc = SimpleDocTemplate(buf, pagesize=A4, topMargin=8*mm, bottomMargin=8*mm,
                            leftMargin=10*mm, rightMargin=10*mm)
    elts = []; styles = getSampleStyleSheet()
    bleu=colors.HexColor('#0D1B2A'); vert=colors.HexColor('#16a34a')
    rouge=colors.HexColor('#dc2626'); gris_clair=colors.HexColor('#f5f5f5')
    gris_header=colors.HexColor('#eef2f7')
    titre_s=ParagraphStyle('Titre',parent=styles['Heading1'],fontSize=13,textColor=bleu,spaceAfter=0)
    section_s=ParagraphStyle('Section',parent=styles['Heading2'],fontSize=9,textColor=bleu,spaceAfter=0)
    small_s=ParagraphStyle('Small',parent=styles['Normal'],fontSize=7.5,textColor=colors.HexColor('#555555'))
    elts.append(Paragraph(f"Piemme — {MOIS_NOM[mois]} {annee}", titre_s))
    elts.append(Spacer(1,1.5*mm))
    env_dep=round(total_dep/NB_JOURS_ENVELOPPE,2) if total_dep else 0
    env_eco=round(total_rec*pct_eco/100,2)
    env_rec=round(total_recurrentes/NB_JOURS_ENVELOPPE,2) if total_recurrentes else 0
    resume_txt=(f"Rec: {total_rec:.2f}€  |  Dép: {total_dep:.2f}€  |  TVA: {total_tva:.2f}€  |  "
                f"Bénéf: {benefice:.2f}€  |  D/j: {env_dep:.2f} · TVA: {total_tva:.2f} · "
                f"Ép({pct_eco:.0f}%): {env_eco:.2f} · Réc/j: {env_rec:.2f}")
    elts.append(Paragraph(resume_txt, small_s)); elts.append(Spacer(1,3*mm))

    col_label=9*mm; col_jour=12.5*mm; col_tot=13*mm
    col_widths=[col_label]+[col_jour]*7+[col_tot]
    cal_rows=[]; cal_styles=[]; row_idx=0
    for wi,week in enumerate(weeks):
        header=['']+[f"{JOURS_SEM[i]}{d}" if d is not None else '' for i,d in enumerate(week)]+['Tot.']
        cal_rows.append(header)
        cal_styles+=[('BACKGROUND',(0,row_idx),(-1,row_idx),gris_header),
                     ('FONTNAME',(0,row_idx),(-1,row_idx),'Helvetica-Bold'),
                     ('FONTSIZE',(0,row_idx),(-1,row_idx),6.5),
                     ('TEXTCOLOR',(0,row_idx),(-1,row_idx),colors.HexColor('#555555'))]
        row_idx+=1
        rec_row=['Rec.']; week_rec=0
        for d in week:
            if d is not None and d in jours_map: v=float(jours_map[d].recette); rec_row.append(f"{v:.2f}" if v>0 else '—'); week_rec+=v
            else: rec_row.append('—' if d is not None else '')
        rec_row.append(f"{week_rec:.2f}"); cal_rows.append(rec_row)
        cal_styles+=[('TEXTCOLOR',(0,row_idx),(0,row_idx),vert),('FONTNAME',(0,row_idx),(0,row_idx),'Helvetica-Bold'),
                     ('TEXTCOLOR',(-1,row_idx),(-1,row_idx),vert),('FONTNAME',(-1,row_idx),(-1,row_idx),'Helvetica-Bold')]
        for ci,d in enumerate(week):
            if d is not None and d in jours_map and float(jours_map[d].recette)>0:
                cal_styles.append(('TEXTCOLOR',(ci+1,row_idx),(ci+1,row_idx),vert))
        row_idx+=1
        dep_row=['Dép.']; week_dep=0
        for d in week:
            if d is not None and d in jours_map: v=float(jours_map[d].depense); dep_row.append(f"{v:.2f}" if v>0 else '—'); week_dep+=v
            else: dep_row.append('—' if d is not None else '')
        dep_row.append(f"{week_dep:.2f}"); cal_rows.append(dep_row)
        cal_styles+=[('TEXTCOLOR',(0,row_idx),(0,row_idx),rouge),('FONTNAME',(0,row_idx),(0,row_idx),'Helvetica-Bold'),
                     ('TEXTCOLOR',(-1,row_idx),(-1,row_idx),rouge),('FONTNAME',(-1,row_idx),(-1,row_idx),'Helvetica-Bold'),
                     ('LINEBELOW',(0,row_idx),(-1,row_idx),1,colors.HexColor('#cccccc'))]
        for ci,d in enumerate(week):
            if d is not None and d in jours_map and float(jours_map[d].depense)>0:
                cal_styles.append(('TEXTCOLOR',(ci+1,row_idx),(ci+1,row_idx),rouge))
        row_idx+=1

    t_cal=Table(cal_rows,colWidths=col_widths)
    base_styles=[('FONTSIZE',(0,0),(-1,-1),6.5),('ALIGN',(1,0),(-1,-1),'RIGHT'),('ALIGN',(0,0),(0,-1),'LEFT'),
                 ('VALIGN',(0,0),(-1,-1),'MIDDLE'),('TOPPADDING',(0,0),(-1,-1),1.5),
                 ('BOTTOMPADDING',(0,0),(-1,-1),1.5),('LEFTPADDING',(0,0),(-1,-1),2),
                 ('RIGHTPADDING',(0,0),(-1,-1),2),('GRID',(0,0),(-1,-1),0.3,colors.HexColor('#dddddd')),
                 ('FONTNAME',(-1,0),(-1,-1),'Helvetica-Bold'),
                 ('TEXTCOLOR',(1,0),(-2,-1),colors.HexColor('#cccccc'))]
    t_cal.setStyle(TableStyle(base_styles+cal_styles))

    depenses_triees=sorted(details,key=lambda d:(d.date.day,d.id))
    dep_rows=[['Jr','Montant','Libellé']]
    if depenses_triees:
        for d in depenses_triees:
            lib=d.libelle or '—'; lib=lib[:25]+'…' if len(lib)>26 else lib
            dep_rows.append([str(d.date.day).zfill(2),f"{float(d.montant):.2f}",lib])
        dep_rows.append(['Total',f"{total_details:.2f}",''])
    else: dep_rows.append(['—','—','Aucune dépense'])
    t_dep=Table(dep_rows,colWidths=[8*mm,16*mm,44*mm])
    dep_style=[('BACKGROUND',(0,0),(-1,0),bleu),('TEXTCOLOR',(0,0),(-1,0),colors.white),
               ('FONTNAME',(0,0),(-1,0),'Helvetica-Bold'),('FONTSIZE',(0,0),(-1,-1),6.5),
               ('ALIGN',(0,0),(0,-1),'CENTER'),('ALIGN',(1,0),(1,-1),'RIGHT'),
               ('GRID',(0,0),(-1,-1),0.3,colors.HexColor('#cccccc')),
               ('TOPPADDING',(0,0),(-1,-1),1.5),('BOTTOMPADDING',(0,0),(-1,-1),1.5),
               ('LEFTPADDING',(0,0),(-1,-1),2),('RIGHTPADDING',(0,0),(-1,-1),2)]
    if depenses_triees:
        dep_style+=[('TEXTCOLOR',(1,1),(1,-2),rouge),('FONTNAME',(1,1),(1,-1),'Helvetica-Bold'),
                    ('ROWBACKGROUNDS',(0,1),(-1,-2),[colors.white,gris_clair]),
                    ('BACKGROUND',(0,-1),(-1,-1),colors.HexColor('#fef2f2')),
                    ('FONTNAME',(0,-1),(-1,-1),'Helvetica-Bold'),('TEXTCOLOR',(1,-1),(1,-1),rouge)]
    else: dep_style.append(('TEXTCOLOR',(0,1),(-1,1),colors.HexColor('#aaaaaa')))
    t_dep.setStyle(TableStyle(dep_style))

    largeur_cal=col_label+7*col_jour+col_tot
    outer=Table([[t_cal,'',[ Paragraph('DÉPENSES DU MOIS',section_s),Spacer(1,1.5*mm),t_dep]]],
                colWidths=[largeur_cal,3*mm,68*mm])
    outer.setStyle(TableStyle([('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),0),
                               ('RIGHTPADDING',(0,0),(-1,-1),0),('TOPPADDING',(0,0),(-1,-1),0),
                               ('BOTTOMPADDING',(0,0),(-1,-1),0)]))
    elts.append(outer); elts.append(Spacer(1,5*mm))

    recap={}
    for d in details: cle=d.libelle or 'Sans libellé'; recap[cle]=recap.get(cle,0)+float(d.montant)
    if recap:
        elts.append(Paragraph('RÉCAPITULATIF DES DÉPENSES',section_s)); elts.append(Spacer(1,2*mm))
        recap_rows=[['Libellé','Montant']]+[[l,f"{t:.2f} €"] for l,t in sorted(recap.items(),key=lambda x:-x[1])]
        recap_rows.append(['TOTAL',f"{total_details:.2f} €"])
        t_recap=Table(recap_rows,hAlign='LEFT')
        t_recap.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),bleu),('TEXTCOLOR',(0,0),(-1,0),colors.white),
                                     ('FONTNAME',(0,0),(-1,0),'Helvetica-Bold'),('FONTSIZE',(0,0),(-1,-1),8),
                                     ('ALIGN',(1,0),(1,-1),'RIGHT'),('ROWBACKGROUNDS',(0,1),(-1,-2),[colors.white,gris_clair]),
                                     ('GRID',(0,0),(-1,-1),0.3,colors.HexColor('#cccccc')),
                                     ('TOPPADDING',(0,0),(-1,-1),2),('BOTTOMPADDING',(0,0),(-1,-1),2),
                                     ('BACKGROUND',(0,-1),(-1,-1),colors.HexColor('#fef2f2')),
                                     ('FONTNAME',(0,-1),(-1,-1),'Helvetica-Bold'),('TEXTCOLOR',(1,-1),(1,-1),rouge)]))
        elts.append(t_recap)

    if recurrentes:
        elts.append(Spacer(1,4*mm)); elts.append(Paragraph('DÉPENSES RÉCURRENTES',section_s))
        elts.append(Spacer(1,2*mm))
        dr_rows=[['Libellé','Montant']]+[[r.libelle,f"{float(r.montant):.2f} €"] for r in recurrentes]
        dr_rows.append(['TOTAL',f"{total_recurrentes:.2f} €"])
        t_dr=Table(dr_rows,hAlign='LEFT')
        t_dr.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),bleu),('TEXTCOLOR',(0,0),(-1,0),colors.white),
                                  ('FONTNAME',(0,0),(-1,0),'Helvetica-Bold'),('FONTSIZE',(0,0),(-1,-1),8),
                                  ('ALIGN',(1,0),(1,-1),'RIGHT'),('ROWBACKGROUNDS',(0,1),(-1,-2),[colors.white,gris_clair]),
                                  ('GRID',(0,0),(-1,-1),0.3,colors.HexColor('#cccccc')),
                                  ('TOPPADDING',(0,0),(-1,-1),2),('BOTTOMPADDING',(0,0),(-1,-1),2),
                                  ('BACKGROUND',(0,-1),(-1,-1),colors.HexColor('#e0f2e9')),
                                  ('FONTNAME',(0,-1),(-1,-1),'Helvetica-Bold')]))
        elts.append(t_dr)

    elts.append(Spacer(1,6*mm))
    footer_s=ParagraphStyle('Footer',parent=styles['Normal'],fontSize=7,textColor=colors.gray,alignment=1)
    elts.append(Paragraph(f"Généré le {datetime.now().strftime('%d/%m/%Y')} — Piemme",footer_s))
    doc.build(elts); buf.seek(0)
    filename=f"piemme_{MOIS_NOM[mois]}_{annee}.pdf"
    disposition="inline" if inline else "attachment"
    return StreamingResponse(buf,media_type="application/pdf",
                             headers={"Content-Disposition":f'{disposition}; filename="{filename}"'})


# ── PDF annuel ────────────────────────────────────────────────

@router.get("/annuel/{annee}/pdf", dependencies=[])
def pdf_annuel(
    annee: int,
    request: Request,
    token: str = None,
    inline: bool = False,
    db: Session = Depends(get_db),
):
    _auth_token(token, db, request)

    import io
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.units import mm
    from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Spacer, Paragraph
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

    jours = (
        db.query(PiemmeJour)
        .filter(extract("year", PiemmeJour.date) == annee)
        .order_by(PiemmeJour.date)
        .all()
    )

    # Grouper par mois
    mois_data = {}
    for j in jours:
        m = j.date.month
        if m not in mois_data:
            mois_data[m] = {"total_recettes": 0, "total_depenses": 0}
        mois_data[m]["total_recettes"] += float(j.recette)
        mois_data[m]["total_depenses"] += float(j.depense)

    for m in mois_data:
        d = mois_data[m]
        d["total_tva"] = round(d["total_recettes"] * 21 / 100, 2)
        d["benefice"] = round(d["total_recettes"] - d["total_depenses"] - d["total_tva"], 2)

    total_rec = sum(d["total_recettes"] for d in mois_data.values())
    total_dep = sum(d["total_depenses"] for d in mois_data.values())
    total_tva = round(total_rec * 21 / 100, 2)
    total_ben = round(total_rec - total_dep - total_tva, 2)

    buf = io.BytesIO()
    doc = SimpleDocTemplate(buf, pagesize=A4, topMargin=12*mm, bottomMargin=12*mm,
                            leftMargin=12*mm, rightMargin=12*mm)
    elts = []
    styles = getSampleStyleSheet()

    bleu = colors.HexColor('#0D1B2A')
    vert = colors.HexColor('#16a34a')
    rouge = colors.HexColor('#dc2626')
    orange = colors.HexColor('#d97706')
    gris_clair = colors.HexColor('#f9fafb')

    titre_s = ParagraphStyle('Titre', parent=styles['Heading1'], fontSize=16, textColor=bleu)
    section_s = ParagraphStyle('Section', parent=styles['Heading2'], fontSize=11, textColor=bleu)

    elts.append(Paragraph(f"Piemme — Année {annee}", titre_s))
    elts.append(Spacer(1, 3*mm))

    resume_data = [
        ['Recettes', 'Dépenses', 'TVA 21%', 'Bénéfice'],
        [f"{total_rec:.2f} €", f"{total_dep:.2f} €", f"{total_tva:.2f} €", f"{total_ben:.2f} €"],
    ]
    t_res = Table(resume_data, colWidths=[42*mm, 42*mm, 42*mm, 42*mm])
    t_res.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), bleu),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('FONTNAME', (0, 0), (-1, -1), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 9),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('GRID', (0, 0), (-1, -1), 0.3, colors.HexColor('#cccccc')),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
        ('TEXTCOLOR', (0, 1), (0, 1), vert),
        ('TEXTCOLOR', (1, 1), (1, 1), rouge),
        ('TEXTCOLOR', (2, 1), (2, 1), orange),
        ('TEXTCOLOR', (3, 1), (3, 1), vert if total_ben >= 0 else rouge),
    ]))
    elts.append(t_res)
    elts.append(Spacer(1, 6*mm))

    elts.append(Paragraph('DÉTAIL PAR MOIS', section_s))
    elts.append(Spacer(1, 2*mm))

    header = ['Mois', 'Recettes', 'Dépenses', 'TVA 21%', 'Bénéfice']
    rows = [header]
    for m in range(1, 13):
        d = mois_data.get(m)
        if d:
            rows.append([
                MOIS_NOM[m],
                f"{d['total_recettes']:.2f}",
                f"{d['total_depenses']:.2f}",
                f"{d['total_tva']:.2f}",
                f"{d['benefice']:.2f}",
            ])
        else:
            rows.append([MOIS_NOM[m], '—', '—', '—', '—'])
    rows.append(['TOTAL', f"{total_rec:.2f}", f"{total_dep:.2f}", f"{total_tva:.2f}", f"{total_ben:.2f}"])

    t_mois = Table(rows, colWidths=[35*mm, 33*mm, 33*mm, 33*mm, 33*mm])
    style_cmds = [
        ('BACKGROUND', (0, 0), (-1, 0), bleu),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 9),
        ('ALIGN', (1, 0), (-1, -1), 'RIGHT'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -2), [colors.white, gris_clair]),
        ('GRID', (0, 0), (-1, -1), 0.3, colors.HexColor('#cccccc')),
        ('TOPPADDING', (0, 0), (-1, -1), 3),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 3),
        ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#e0f2e9')),
        ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
    ]
    for idx, m in enumerate(range(1, 13)):
        d = mois_data.get(m)
        if d and d['benefice'] < 0:
            style_cmds.append(('TEXTCOLOR', (4, idx + 1), (4, idx + 1), rouge))
    t_mois.setStyle(TableStyle(style_cmds))
    elts.append(t_mois)

    elts.append(Spacer(1, 8*mm))
    footer_s = ParagraphStyle('Footer', parent=styles['Normal'], fontSize=7, textColor=colors.gray, alignment=1)
    elts.append(Paragraph(f"Généré le {datetime.now().strftime('%d/%m/%Y')} — Piemme", footer_s))

    doc.build(elts)
    buf.seek(0)

    filename = f"piemme_annuel_{annee}.pdf"
    disposition = "inline" if inline else "attachment"
    return StreamingResponse(
        buf, media_type="application/pdf",
        headers={"Content-Disposition": f'{disposition}; filename="{filename}"'},
    )
