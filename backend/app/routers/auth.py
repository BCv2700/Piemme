from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.utilisateur import Utilisateur
from app.schemas.utilisateur import LoginRequest, TokenResponse
from app.auth import verifier_mot_de_passe, creer_token

router = APIRouter(prefix="/auth", tags=["Authentification"])


@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    utilisateur = db.query(Utilisateur).filter(Utilisateur.username == payload.username).first()

    if not utilisateur or not utilisateur.actif or not verifier_mot_de_passe(payload.mot_de_passe, utilisateur.mot_de_passe):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Nom d'utilisateur ou mot de passe incorrect",
        )

    token = creer_token(utilisateur.username)
    return TokenResponse(access_token=token, username=utilisateur.username)