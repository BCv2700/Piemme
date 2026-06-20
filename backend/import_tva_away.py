"""
Script d'import : remplit le champ tva_away des articles existants en Postgres
à partir du fichier Excel original T_Articles (export Access).

Correspondance utilisée : Ref_Article (Excel) == id (Postgres), confirmé manuellement
sur l'article "PROSECCO Bouteille" (id=1).

Usage :
    python import_tva_away.py /chemin/vers/T_Articles.xlsx
"""
import sys
import os
from decimal import Decimal

import openpyxl
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    print("ERREUR : la variable DATABASE_URL n'a pas été trouvée dans le fichier .env")
    sys.exit(1)

if len(sys.argv) < 2:
    print("Usage : python import_tva_away.py /chemin/vers/T_Articles.xlsx")
    sys.exit(1)

chemin_excel = sys.argv[1]

# --- Lecture du fichier Excel ---
wb = openpyxl.load_workbook(chemin_excel, read_only=True)
ws = wb["T_Articles"]
rows = list(ws.iter_rows(min_row=2, values_only=True))

# Colonnes : 0 = Ref_Article, 1 = A_Denom_Article, 5 = A_TVA_Away
donnees = []
for r in rows:
    ref_article = r[0]
    nom = r[1]
    tva_away = r[5]
    if ref_article is not None and tva_away is not None:
        donnees.append((int(ref_article), nom, Decimal(str(tva_away))))

print(f"{len(donnees)} lignes lues dans le fichier Excel.")

# --- Connexion à la base ---
engine = create_engine(DATABASE_URL)

mis_a_jour = 0
introuvables = []

with engine.begin() as conn:
    for ref_article, nom, tva_away in donnees:
        result = conn.execute(
            text("UPDATE articles SET tva_away = :tva_away WHERE id = :id"),
            {"tva_away": tva_away, "id": ref_article},
        )
        if result.rowcount == 0:
            introuvables.append((ref_article, nom))
        else:
            mis_a_jour += 1

print(f"\n{mis_a_jour} articles mis à jour avec succès.")

if introuvables:
    print(f"\n{len(introuvables)} référence(s) du fichier Excel n'ont PAS été trouvées en base :")
    for ref_article, nom in introuvables:
        print(f"  - id {ref_article} ({nom})")
else:
    print("Toutes les références ont été trouvées et mises à jour.")
