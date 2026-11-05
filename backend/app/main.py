from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

env_file = os.getenv("ENV_FILE", ".env")
load_dotenv(env_file)

from app.routers import auth, piemme, admin
from app.database import Base, engine
from app.models import utilisateur, piemme as piemme_model

Base.metadata.create_all(bind=engine)

# Resynchroniser les séquences PostgreSQL au démarrage
def _reset_sequences():
    tables = [
        "piemme_jour",
        "piemme_depense_detail",
        "piemme_depense_recurrente",
        "piemme_facture_retard",
        "piemme_enveloppe",
        "piemme_config",
        "utilisateur",
    ]
    with engine.connect() as conn:
        for table in tables:
            try:
                conn.execute(__import__('sqlalchemy').text(
                    f"SELECT setval('{table}_id_seq', COALESCE((SELECT MAX(id) FROM {table}), 1))"
                ))
            except Exception:
                pass
        conn.commit()

_reset_sequences()

app = FastAPI(
    title=os.getenv("APP_NAME", "Piemme"),
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://soft.chezpiemme.be",
        "http://localhost:5173",
        "http://localhost:5174",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(piemme.router)
app.include_router(piemme.cron_router)
app.include_router(admin.router)

@app.get("/")
def root():
    return {"message": "API Piemme opérationnelle"}

@app.get("/health")
def health():
    return {"status": "ok"}
