from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

load_dotenv()

from app.routers import auth, piemme
from app.database import Base, engine
from app.models import utilisateur, piemme as piemme_model

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=os.getenv("APP_NAME", "Piemme"),
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(piemme.router)

@app.get("/")
def root():
    return {"message": "API Piemme opérationnelle"}

@app.get("/health")
def health():
    return {"status": "ok"}
