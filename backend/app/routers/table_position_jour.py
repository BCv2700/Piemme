from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.dialects.postgresql import insert as pg_insert
from datetime import date, datetime
from typing import Optional
from app.database import get_db
from app.models.table_position_jour import TablePositionJour
from app.models.table import Table
from app.schemas.table_position_jour import (
    TablePositionJourOut,
    TablePositionJourUpsert,
    TablePositionJourStatutUpsert,
    TablePositionJourHeureArriveeUpsert,
)
from app.deps import get_current_user
from app.models.utilisateur import Utilisateur

router = APIRouter(prefix="/table-positions-jour", tags=["TablePositionsJour"])


@router.get("/", response_model=list[TablePositionJourOut])
def list_positions_jour(
    date_jour: Optional[date] = None,
    db: Session = Depends(get_db),
    utilisateur: Utilisateur = Depends(get_current_user),
):
    """
    Renvoie les exceptions de position pour un jour donné.
    Le frontend doit fusionner ce résultat avec la disposition de référence
    (Table.pos_x / Table.pos_y) pour les tables qui n'ont pas d'exception ce jour-là.
    """
    query = db.query(TablePositionJour)
    if date_jour:
        query = query.filter(TablePositionJour.date == date_jour)
    return query.all()


@router.put("/", response_model=TablePositionJourOut)
def upsert_position_jour(payload: TablePositionJourUpsert, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Enregistre la position d'une table pour un jour donné.

    - Si definir_reference=True : met à jour la disposition de référence (Table.pos_x/pos_y)
      directement, et supprime toute exception existante pour ce jour précis
      (puisque la référence devient la nouvelle position par défaut, l'exception
      du jour n'a plus de raison d'exister).
    - Sinon : upsert atomique (INSERT ... ON CONFLICT DO UPDATE) sur la contrainte
      unique (table_id, date), pour éviter toute violation de contrainte en cas
      d'appels rapprochés (ex: glissements successifs d'une même table).
    """
    table = db.query(Table).filter(Table.id == payload.table_id).first()
    if not table:
        raise HTTPException(status_code=404, detail="Table introuvable")

    if payload.definir_reference:
        table.pos_x = payload.pos_x
        table.pos_y = payload.pos_y

        db.query(TablePositionJour).filter(
            TablePositionJour.table_id == payload.table_id,
            TablePositionJour.date == payload.date,
        ).delete()

        db.commit()
        db.refresh(table)
        return TablePositionJourOut(
            id=0,
            table_id=table.id,
            date=payload.date,
            pos_x=table.pos_x,
            pos_y=table.pos_y,
        )

    stmt = pg_insert(TablePositionJour).values(
        table_id=payload.table_id,
        date=payload.date,
        pos_x=payload.pos_x,
        pos_y=payload.pos_y,
        statut=None,
    )
    stmt = stmt.on_conflict_do_update(
        constraint='uq_table_position_jour_table_date',
        set_={'pos_x': payload.pos_x, 'pos_y': payload.pos_y},
    ).returning(TablePositionJour.id, TablePositionJour.statut, TablePositionJour.heure_arrivee)

    result = db.execute(stmt)
    db.commit()
    row = result.one()

    return TablePositionJourOut(
        id=row.id,
        table_id=payload.table_id,
        date=payload.date,
        pos_x=payload.pos_x,
        pos_y=payload.pos_y,
        statut=row.statut,
        heure_arrivee=row.heure_arrivee,
    )


@router.put("/statut", response_model=TablePositionJourOut)
def upsert_statut_jour(payload: TablePositionJourStatutUpsert, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Enregistre le statut manuel (libre/occupee/reservee/indisponible) d'une table
    pour un jour donné, sans toucher à sa position éventuelle ce jour-là.
    Upsert atomique sur la contrainte unique (table_id, date).

    Heure d'arrivée : dès que le statut passe à "occupee", l'heure d'arrivée est
    enregistrée automatiquement avec l'heure serveur actuelle, MAIS seulement si
    aucune heure d'arrivée n'existe déjà pour ce jour (pour ne pas l'écraser si on
    bascule le statut plusieurs fois, ou si elle a déjà été modifiée manuellement).
    Passer à un autre statut ne touche jamais à l'heure d'arrivée déjà enregistrée.
    """
    table = db.query(Table).filter(Table.id == payload.table_id).first()
    if not table:
        raise HTTPException(status_code=404, detail="Table introuvable")

    existing = db.query(TablePositionJour).filter(
        TablePositionJour.table_id == payload.table_id,
        TablePositionJour.date == payload.date,
    ).first()

    heure_arrivee_val = existing.heure_arrivee if existing else None
    if payload.statut == 'occupee' and heure_arrivee_val is None:
        heure_arrivee_val = datetime.now().time()

    stmt = pg_insert(TablePositionJour).values(
        table_id=payload.table_id,
        date=payload.date,
        pos_x=None,
        pos_y=None,
        statut=payload.statut,
        heure_arrivee=heure_arrivee_val,
    )
    stmt = stmt.on_conflict_do_update(
        constraint='uq_table_position_jour_table_date',
        set_={'statut': payload.statut, 'heure_arrivee': heure_arrivee_val},
    ).returning(TablePositionJour.id, TablePositionJour.pos_x, TablePositionJour.pos_y)

    result = db.execute(stmt)
    db.commit()
    row = result.one()

    return TablePositionJourOut(
        id=row.id,
        table_id=payload.table_id,
        date=payload.date,
        pos_x=row.pos_x,
        pos_y=row.pos_y,
        statut=payload.statut,
        heure_arrivee=heure_arrivee_val,
    )


@router.put("/heure-arrivee", response_model=TablePositionJourOut)
def upsert_heure_arrivee(payload: TablePositionJourHeureArriveeUpsert, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Modifie manuellement l'heure d'arrivée d'une table pour un jour donné,
    sans toucher à son statut ni à sa position éventuelle.
    Upsert atomique sur la contrainte unique (table_id, date).
    """
    table = db.query(Table).filter(Table.id == payload.table_id).first()
    if not table:
        raise HTTPException(status_code=404, detail="Table introuvable")

    stmt = pg_insert(TablePositionJour).values(
        table_id=payload.table_id,
        date=payload.date,
        pos_x=None,
        pos_y=None,
        statut=None,
        heure_arrivee=payload.heure_arrivee,
    )
    stmt = stmt.on_conflict_do_update(
        constraint='uq_table_position_jour_table_date',
        set_={'heure_arrivee': payload.heure_arrivee},
    ).returning(TablePositionJour.id, TablePositionJour.pos_x, TablePositionJour.pos_y, TablePositionJour.statut)

    result = db.execute(stmt)
    db.commit()
    row = result.one()

    return TablePositionJourOut(
        id=row.id,
        table_id=payload.table_id,
        date=payload.date,
        pos_x=row.pos_x,
        pos_y=row.pos_y,
        statut=row.statut,
        heure_arrivee=payload.heure_arrivee,
    )


@router.delete("/{position_id}")
def delete_position_jour(position_id: int, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Supprime une exception de position pour un jour précis (la table retombe
    alors sur la disposition de référence ce jour-là).
    """
    db_position = db.query(TablePositionJour).filter(TablePositionJour.id == position_id).first()
    if not db_position:
        raise HTTPException(status_code=404, detail="Position introuvable")
    db.delete(db_position)
    db.commit()
    return {"message": "Position supprimée"}


@router.delete("/jour/{date_jour}")
def reset_positions_jour(date_jour: date, db: Session = Depends(get_db), utilisateur: Utilisateur = Depends(get_current_user)):
    """
    Supprime TOUTES les exceptions de position pour le jour donné en une seule fois.
    Toutes les tables de ce jour retombent alors sur la disposition de référence.
    """
    nb_supprimees = db.query(TablePositionJour).filter(TablePositionJour.date == date_jour).delete()
    db.commit()
    return {"message": f"{nb_supprimees} position(s) réinitialisée(s) pour le {date_jour}"}