from pydantic import BaseModel
from datetime import date as date_type

class TablePositionJourBase(BaseModel):
    table_id: int
    date: date_type
    pos_x: int
    pos_y: int

class TablePositionJourUpsert(BaseModel):
    table_id: int
    date: date_type
    pos_x: int
    pos_y: int
    definir_reference: bool = False

class TablePositionJourOut(TablePositionJourBase):
    id: int

    class Config:
        from_attributes = True
