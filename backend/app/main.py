from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from app.routers import table_position_jour
from app.routers import tables, articles, clients, commandes, encaissements, reservations, recap_mensuel
from app.routers import tables, articles, clients, commandes, encaissements, reservations, recap_mensuel, auth
from app.routers import article_achat
from app.routers import article_composant
from app.routers import statistiques
from app.routers import service_personnel

import os

load_dotenv()

app = FastAPI(
    title=os.getenv("APP_NAME", "L'Olive"),
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(tables.router)
app.include_router(articles.router)
app.include_router(clients.router)
app.include_router(commandes.router)
app.include_router(encaissements.router)
app.include_router(reservations.router)
app.include_router(table_position_jour.router)
app.include_router(recap_mensuel.router)
app.include_router(auth.router)
app.include_router(article_achat.router)
app.include_router(article_composant.router)
app.include_router(statistiques.router)
app.include_router(service_personnel.router)

@app.get("/")
def root():
    return {"message": "API L'Olive operationnelle"}

@app.get("/health")
def health():
    return {"status": "ok"}