from pydantic import BaseModel


class LoginRequest(BaseModel):
    username: str
    mot_de_passe: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    username: str
    role: str


class UtilisateurOut(BaseModel):
    id: int
    username: str
    actif: bool
    role: str

    class Config:
        from_attributes = True


class UtilisateurCreate(BaseModel):
    username: str
    mot_de_passe: str
    role: str = 'admin'


class UtilisateurUpdate(BaseModel):
    role: str | None = None
    actif: bool | None = None
    mot_de_passe: str | None = None
