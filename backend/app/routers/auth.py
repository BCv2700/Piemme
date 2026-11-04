from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.utilisateur import Utilisateur
from app.schemas.utilisateur import LoginRequest, TokenResponse, UtilisateurOut, UtilisateurCreate, UtilisateurUpdate
from app.auth import verifier_mot_de_passe, creer_token, hasher_mot_de_passe
from app.deps import get_current_user, require_admin

router = APIRouter(prefix="/auth", tags=["Authentification"])


@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    utilisateur = db.query(Utilisateur).filter(Utilisateur.username == payload.username).first()
    if not utilisateur or not utilisateur.actif or not verifier_mot_de_passe(payload.mot_de_passe, utilisateur.mot_de_passe):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Nom d'utilisateur ou mot de passe incorrect")
    token = creer_token(utilisateur.username, utilisateur.role)
    return TokenResponse(access_token=token, username=utilisateur.username, role=utilisateur.role)


@router.post("/changer-mot-de-passe")
def changer_mot_de_passe(payload: dict, db: Session = Depends(get_db)):
    username = (payload.get("username") or "").strip()
    ancien = payload.get("ancien", ""); nouveau = payload.get("nouveau", "")
    if not username or not ancien or not nouveau: raise HTTPException(400, "Champs requis: username, ancien, nouveau")
    if len(nouveau) < 4: raise HTTPException(400, "Le nouveau mot de passe doit faire au moins 4 caractères")
    utilisateur = db.query(Utilisateur).filter(Utilisateur.username == username).first()
    if not utilisateur or not verifier_mot_de_passe(ancien, utilisateur.mot_de_passe):
        raise HTTPException(401, "Ancien mot de passe incorrect")
    utilisateur.mot_de_passe = hasher_mot_de_passe(nouveau); db.commit()
    return {"ok": True, "message": "Mot de passe modifié"}


@router.get("/utilisateurs", response_model=list[UtilisateurOut])
def lister_utilisateurs(db: Session = Depends(get_db), _: Utilisateur = Depends(require_admin)):
    return db.query(Utilisateur).order_by(Utilisateur.id).all()


@router.post("/utilisateurs", response_model=UtilisateurOut, status_code=201)
def creer_utilisateur(payload: UtilisateurCreate, db: Session = Depends(get_db), _: Utilisateur = Depends(require_admin)):
    if payload.role not in ('admin', 'serveur'): raise HTTPException(400, "Rôle: 'admin' ou 'serveur'")
    if db.query(Utilisateur).filter(Utilisateur.username == payload.username).first():
        raise HTTPException(409, f"L'identifiant '{payload.username}' est déjà utilisé")
    if len(payload.mot_de_passe) < 4: raise HTTPException(400, "Min 4 caractères")
    u = Utilisateur(username=payload.username, mot_de_passe=hasher_mot_de_passe(payload.mot_de_passe),
                    role=payload.role, actif=True)
    db.add(u); db.commit(); db.refresh(u)
    return u


@router.post("/reset-mot-de-passe")
def reset_mot_de_passe(payload: dict, db: Session = Depends(get_db), _: Utilisateur = Depends(require_admin)):
    username = (payload.get("username") or "").strip()
    nouveau = payload.get("nouveau", "")
    if not username or not nouveau: raise HTTPException(400, "Champs requis: username, nouveau")
    if len(nouveau) < 4: raise HTTPException(400, "Le nouveau mot de passe doit faire au moins 4 caractères")
    utilisateur = db.query(Utilisateur).filter(Utilisateur.username == username).first()
    if not utilisateur: raise HTTPException(404, "Utilisateur introuvable")
    utilisateur.mot_de_passe = hasher_mot_de_passe(nouveau); db.commit()
    return {"ok": True, "message": f"Mot de passe de '{username}' réinitialisé"}


@router.put("/utilisateurs/{utilisateur_id}")
def modifier_utilisateur(utilisateur_id: int, payload: dict, db: Session = Depends(get_db), _: Utilisateur = Depends(require_admin)):
    u = db.query(Utilisateur).filter(Utilisateur.id == utilisateur_id).first()
    if not u: raise HTTPException(404, "Utilisateur introuvable")
    if "actif" in payload: u.actif = payload["actif"]
    if "role" in payload:
        if payload["role"] not in ('admin', 'serveur'): raise HTTPException(400, "Rôle: 'admin' ou 'serveur'")
        u.role = payload["role"]
    db.commit(); db.refresh(u)
    return {"ok": True}


@router.delete("/utilisateurs/{utilisateur_id}")
def supprimer_utilisateur(utilisateur_id: int, db: Session = Depends(get_db),
                          current: Utilisateur = Depends(require_admin)):
    u = db.query(Utilisateur).filter(Utilisateur.id == utilisateur_id).first()
    if not u: raise HTTPException(404, "Utilisateur introuvable")
    if u.id == current.id: raise HTTPException(400, "Impossible de supprimer son propre compte")
    db.delete(u); db.commit()
    return {"ok": True, "message": f"Compte '{u.username}' supprimé"}
