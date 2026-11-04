from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from sqlalchemy import text
import os
import io
import zipfile
import json
from datetime import datetime

from app.database import get_db
from app.deps import get_current_user, require_admin
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/admin", tags=["Administration"])

TABLES = [
    "utilisateurs",
    "piemme_jour",
    "piemme_depense_recurrente",
    "piemme_config",
    "piemme_depense_detail",
    "piemme_enveloppe",
    "piemme_facture_retard",
]


@router.get("/info")
def info_env(_: Utilisateur = Depends(get_current_user)):
    """Retourne l'environnement courant (local vs prod)."""
    env = os.getenv("APP_ENV", "production")
    db_url = os.getenv("DATABASE_URL", "")
    db_name = db_url.split("/")[-1] if "/" in db_url else "inconnue"
    return {"env": env, "db": db_name}


@router.get("/dump")
def dump_db(db: Session = Depends(get_db), _: Utilisateur = Depends(require_admin)):
    """Exporte toutes les tables en JSON."""
    resultat = {}
    for table in TABLES:
        try:
            rows = db.execute(text(f"SELECT * FROM {table}")).mappings().all()
            resultat[table] = [dict(r) for r in rows]
        except Exception as e:
            resultat[table] = {"erreur": str(e)}
    return resultat


@router.post("/restore-dump")
def restore_dump(dump: dict, db: Session = Depends(get_db), _: Utilisateur = Depends(require_admin)):
    """Importe un dump JSON dans la base courante (écrase les données existantes)."""
    resultats = {}
    for table, rows in dump.items():
        if table not in TABLES:
            resultats[table] = "ignorée (table inconnue)"
            continue
        if isinstance(rows, dict) and "erreur" in rows:
            resultats[table] = f"ignorée (erreur source : {rows['erreur']})"
            continue
        try:
            db.execute(text(f"DELETE FROM {table}"))
            if rows:
                cols = list(rows[0].keys())
                for row in rows:
                    vals = {c: row.get(c) for c in cols}
                    placeholders = ", ".join([f":{c}" for c in cols])
                    col_names = ", ".join(cols)
                    db.execute(text(f"INSERT INTO {table} ({col_names}) VALUES ({placeholders})"), vals)
            # Resync sequences
            if "id" in (rows[0].keys() if rows else []):
                db.execute(text(
                    f"SELECT setval(pg_get_serial_sequence('{table}', 'id'), "
                    f"COALESCE((SELECT MAX(id) FROM {table}), 1))"
                ))
            db.commit()
            resultats[table] = f"{len(rows)} lignes importées"
        except Exception as e:
            db.rollback()
            resultats[table] = f"erreur : {str(e)}"
    return {"resultats": resultats}


@router.get("/backup")
def backup(db: Session = Depends(get_db), _: Utilisateur = Depends(require_admin)):
    """Génère un ZIP contenant le dump SQL JSON + le code source du backend."""
    # Dump JSON
    dump = {}
    for table in TABLES:
        try:
            rows = db.execute(text(f"SELECT * FROM {table}")).mappings().all()
            dump[table] = [dict(r) for r in rows]
        except Exception as e:
            dump[table] = {"erreur": str(e)}

    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        # Dump JSON
        dump_json = json.dumps(dump, ensure_ascii=False, indent=2, default=str)
        date_str = datetime.now().strftime("%Y-%m-%d_%H-%M")
        zf.writestr(f"piemme_dump_{date_str}.json", dump_json)

        # Code source backend
        backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        for root, dirs, files in os.walk(backend_dir):
            # Exclure __pycache__ et venv
            dirs[:] = [d for d in dirs if d not in ("__pycache__", "venv", ".venv", ".git")]
            for fname in files:
                if fname.endswith((".py", ".txt", ".env.example", ".toml", ".cfg")):
                    fpath = os.path.join(root, fname)
                    arcname = os.path.relpath(fpath, os.path.dirname(backend_dir))
                    try:
                        zf.write(fpath, arcname)
                    except Exception:
                        pass

    buf.seek(0)
    date_str2 = datetime.now().strftime("%Y-%m-%d_%H-%M")
    return StreamingResponse(
        buf,
        media_type="application/zip",
        headers={"Content-Disposition": f'attachment; filename="piemme_backup_{date_str2}.zip"'}
    )
