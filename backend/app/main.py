from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from app.routers import table_position_jour
from app.routers import tables, articles, clients, commandes, encaissements, reservations, recap_mensuel

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

@app.get("/")
def root():
    return {"message": "API L'Olive operationnelle"}

@app.get("/health")
def health():
    return {"status": "ok"}
