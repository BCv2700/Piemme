from sqlalchemy import Column, Integer, Date, String, ForeignKey, UniqueConstraint
from app.database import Base

class TablePositionJour(Base):
    __tablename__ = 'table_position_jour'
    id        = Column(Integer, primary_key=True, index=True)
    table_id  = Column(Integer, ForeignKey('tables.id'), nullable=False)
    date      = Column(Date, nullable=False)
    pos_x     = Column(Integer, nullable=True)
    pos_y     = Column(Integer, nullable=True)
    statut    = Column(String(20), nullable=True)

    __table_args__ = (
        UniqueConstraint('table_id', 'date', name='uq_table_position_jour_table_date'),
    )
