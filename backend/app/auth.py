from datetime import datetime, timedelta, timezone
from passlib.context import CryptContext
from jose import jwt, JWTError
import os

# Clé secrète utilisée pour signer les jetons. À définir dans les variables
# d'environnement Railway sous le nom SECRET_KEY (voir instructions de déploiement).
# Si elle n'est pas définie, une valeur de secours est utilisée en local UNIQUEMENT
# (ne jamais laisser cette valeur de secours tourner en production).
SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key-a-ne-jamais-utiliser-en-prod")
ALGORITHM = "HS256"
# Durée de validité du jeton : 1 an. La déconnexion se fait manuellement côté
# frontend (suppression du jeton), pas par expiration courte.
EXPIRATION_JOURS = 365

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hasher_mot_de_passe(mot_de_passe: str) -> str:
    return pwd_context.hash(mot_de_passe)


def verifier_mot_de_passe(mot_de_passe: str, mot_de_passe_hash: str) -> bool:
    return pwd_context.verify(mot_de_passe, mot_de_passe_hash)


def creer_token(username: str) -> str:
    expiration = datetime.now(timezone.utc) + timedelta(days=EXPIRATION_JOURS)
    payload = {"sub": username, "exp": expiration}
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def lire_username_depuis_token(token: str) -> str | None:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload.get("sub")
    except JWTError:
        return None