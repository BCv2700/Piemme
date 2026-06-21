from pydantic import BaseModel
from typing import Optional
from datetime import date as date_type

class TablePositionJourBase(BaseModel):
    table_id: int
    date: date_type
    pos_x: Optional[int] = None
    pos_y: Optional[int] = None
    statut: Optional[str] = None

class TablePositionJourUpsert(BaseModel):
    table_id: int
    date: date_type
    pos_x: int
    pos_y: int
    definir_reference: bool = False

class TablePositionJourStatutUpsert(BaseModel):
    table_id: int
    date: date_type
    statut: str

class TablePositionJourOut(TablePositionJourBase):
    id: int

    class Config:
        from_attributes = True
