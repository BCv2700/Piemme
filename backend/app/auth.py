from datetime import datetime, timedelta, timezone
from passlib.context import CryptContext
from jose import jwt, JWTError
import os

SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key-local-uniquement")
ALGORITHM = "HS256"
EXPIRATION_JOURS = 365

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hasher_mot_de_passe(mot_de_passe: str) -> str:
    return pwd_context.hash(mot_de_passe)


def verifier_mot_de_passe(mot_de_passe: str, mot_de_passe_hash: str) -> bool:
    return pwd_context.verify(mot_de_passe, mot_de_passe_hash)


def creer_token(username: str, role: str = 'admin') -> str:
    expiration = datetime.now(timezone.utc) + timedelta(days=EXPIRATION_JOURS)
    payload = {"sub": username, "role": role, "exp": expiration}
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def lire_username_depuis_token(token: str) -> str | None:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload.get("sub")
    except JWTError:
        return None


def lire_role_depuis_token(token: str) -> str | None:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload.get("role", "admin")
    except JWTError:
        return None
