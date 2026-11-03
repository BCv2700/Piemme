from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.utilisateur import Utilisateur
from app.auth import lire_username_depuis_token, lire_role_depuis_token

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> Utilisateur:
    erreur_auth = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Identifiants invalides ou expirés",
        headers={"WWW-Authenticate": "Bearer"},
    )
    username = lire_username_depuis_token(token)
    if username is None:
        raise erreur_auth
    utilisateur = db.query(Utilisateur).filter(Utilisateur.username == username).first()
    if utilisateur is None or not utilisateur.actif:
        raise erreur_auth
    return utilisateur


def require_admin(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> Utilisateur:
    utilisateur = get_current_user(token=token, db=db)
    role = lire_role_depuis_token(token)
    if role != 'admin':
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Accès réservé aux administrateurs",
        )
    return utilisateur
