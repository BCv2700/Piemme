from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date
from typing import Optional
from app.database import get_db
from app.models.reservation import Reservation
from app.schemas.reservation import ReservationOut, ReservationCreate, ReservationUpdate

router = APIRouter(prefix="/reservations", tags=["Reservations"])

@router.get("/", response_model=list[ReservationOut])
def list_reservations(
    date_reservation: Optional[date] = None,
    db: Session = Depends(get_db),
):
    query = db.query(Reservation)
    if date_reservation:
        query = query.filter(Reservation.date_reservation == date_reservation)
    return query.order_by(Reservation.date_reservation, Reservation.heure).all()

@router.post("/", response_model=ReservationOut)
def create_reservation(reservation: ReservationCreate, db: Session = Depends(get_db)):
    db_reservation = Reservation(**reservation.dict())
    db.add(db_reservation)
    db.commit()
    db.refresh(db_reservation)
    return db_reservation

@router.patch("/{reservation_id}", response_model=ReservationOut)
def update_reservation(reservation_id: int, reservation: ReservationUpdate, db: Session = Depends(get_db)):
    db_reservation = db.query(Reservation).filter(Reservation.id == reservation_id).first()
    if not db_reservation:
        raise HTTPException(status_code=404, detail="Réservation introuvable")
    for key, value in reservation.dict(exclude_unset=True).items():
        setattr(db_reservation, key, value)
    db.commit()
    db.refresh(db_reservation)
    return db_reservation

@router.delete("/{reservation_id}")
def delete_reservation(reservation_id: int, db: Session = Depends(get_db)):
    db_reservation = db.query(Reservation).filter(Reservation.id == reservation_id).first()
    if not db_reservation:
        raise HTTPException(status_code=404, detail="Réservation introuvable")
    db.delete(db_reservation)
    db.commit()
    return {"message": "Réservation supprimée"}
