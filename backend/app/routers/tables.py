from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.table import Table
from app.schemas.table import TableOut, TableCreate, TableUpdate

router = APIRouter(prefix="/tables", tags=["Tables"])

@router.get("/", response_model=list[TableOut])
def list_tables(db: Session = Depends(get_db)):
    return db.query(Table).order_by(Table.nom).all()

@router.get("/{table_id}", response_model=TableOut)
def get_table(table_id: int, db: Session = Depends(get_db)):
    table = db.query(Table).filter(Table.id == table_id).first()
    if not table:
        raise HTTPException(status_code=404, detail="Table introuvable")
    return table

@router.post("/", response_model=TableOut)
def create_table(table: TableCreate, db: Session = Depends(get_db)):
    db_table = Table(**table.dict())
    db.add(db_table)
    db.commit()
    db.refresh(db_table)
    return db_table

@router.patch("/{table_id}", response_model=TableOut)
def update_table(table_id: int, table: TableUpdate, db: Session = Depends(get_db)):
    db_table = db.query(Table).filter(Table.id == table_id).first()
    if not db_table:
        raise HTTPException(status_code=404, detail="Table introuvable")
    for key, value in table.dict(exclude_unset=True).items():
        setattr(db_table, key, value)
    db.commit()
    db.refresh(db_table)
    return db_table

@router.delete("/{table_id}")
def delete_table(table_id: int, db: Session = Depends(get_db)):
    db_table = db.query(Table).filter(Table.id == table_id).first()
    if not db_table:
        raise HTTPException(status_code=404, detail="Table introuvable")
    db.delete(db_table)
    db.commit()
    return {"message": "Table supprimée"}
