from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.dialects.postgresql import insert as pg_insert
from datetime import date
from typing import Optional
from app.database import get_db
from app.models.table_position_jour import TablePositionJour
from app.models.table import Table
from app.schemas.table_position_jour import TablePositionJourOut, TablePositionJourUpsert

router = APIRouter(prefix="/table-positions-jour", tags=["TablePositionsJour"])


@router.get("/", response_model=list[TablePositionJourOut])
def list_positions_jour(
    date_jour: Optional[date] = None,
    db: Session = Depends(get_db),
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
def upsert_position_jour(payload: TablePositionJourUpsert, db: Session = Depends(get_db)):
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
    )
    stmt = stmt.on_conflict_do_update(
        constraint='uq_table_position_jour_table_date',
        set_={'pos_x': payload.pos_x, 'pos_y': payload.pos_y},
    ).returning(TablePositionJour.id)

    result = db.execute(stmt)
    db.commit()
    new_id = result.scalar_one()

    return TablePositionJourOut(
        id=new_id,
        table_id=payload.table_id,
        date=payload.date,
        pos_x=payload.pos_x,
        pos_y=payload.pos_y,
    )


@router.delete("/{position_id}")
def delete_position_jour(position_id: int, db: Session = Depends(get_db)):
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
def reset_positions_jour(date_jour: date, db: Session = Depends(get_db)):
    """
    Supprime TOUTES les exceptions de position pour le jour donné en une seule fois.
    Toutes les tables de ce jour retombent alors sur la disposition de référence.
    """
    nb_supprimees = db.query(TablePositionJour).filter(TablePositionJour.date == date_jour).delete()
    db.commit()
    return {"message": f"{nb_supprimees} position(s) réinitialisée(s) pour le {date_jour}"}
