"""
Script d'import : remplit le champ code_vente des articles existants en Postgres
à partir du fichier Excel original T_Articles (export Access).

Correspondance utilisée : Ref_Article (Excel) == id (Postgres), confirmé manuellement
sur l'article "PROSECCO Bouteille" (id=1).

Codes de vente (table T_Code_Vente d'origine) :
  7001 = Boissons Alcools
  7002 = Nourriture
  7003 = Boissons (Softs)
  7004 = Boissons (Vins)
  7005 = Divers

Usage :
    python import_code_vente.py /chemin/vers/T_Articles.xlsx
"""
import sys
import os

import openpyxl
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    print("ERREUR : la variable DATABASE_URL n'a pas été trouvée dans le fichier .env")
    sys.exit(1)

if len(sys.argv) < 2:
    print("Usage : python import_code_vente.py /chemin/vers/T_Articles.xlsx")
    sys.exit(1)

chemin_excel = sys.argv[1]

# --- Lecture du fichier Excel ---
wb = openpyxl.load_workbook(chemin_excel, read_only=True)
ws = wb["T_Articles"]
rows = list(ws.iter_rows(min_row=2, values_only=True))

# Colonnes : 0 = Ref_Article, 1 = A_Denom_Article, 42 = A_Code_Vente
donnees = []
for r in rows:
    ref_article = r[0]
    nom = r[1]
    code_vente = r[42]
    if ref_article is not None and code_vente is not None:
        donnees.append((int(ref_article), nom, int(code_vente)))

print(f"{len(donnees)} lignes lues dans le fichier Excel.")

# --- Connexion à la base ---
engine = create_engine(DATABASE_URL)

mis_a_jour = 0
introuvables = []

with engine.begin() as conn:
    for ref_article, nom, code_vente in donnees:
        result = conn.execute(
            text("UPDATE articles SET code_vente = :code_vente WHERE id = :id"),
            {"code_vente": code_vente, "id": ref_article},
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
