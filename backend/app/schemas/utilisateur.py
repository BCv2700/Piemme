from pydantic import BaseModel


class LoginRequest(BaseModel):
    username: str
    mot_de_passe: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    username: str


class UtilisateurOut(BaseModel):
    id: int
    username: str
    actif: bool

    class Config:
        from_attributes = True