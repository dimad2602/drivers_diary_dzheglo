import datetime as dt

from sqlalchemy import CheckConstraint, Date, DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base


class TripRow(Base):
    """Поездка в БД.

    Моменты времени хранятся в UTC, а исходное смещение — отдельной колонкой, чтобы в ответе
    вернуть ровно то, что прислал клиент (`+05:00`). `local_date` — дата начала поездки
    в её собственном часовом поясе: по ней отбираются поездки «за день».
    """

    __tablename__ = "trips"
    __table_args__ = (
        CheckConstraint("amount > 0", name="ck_trips_amount_positive"),
        CheckConstraint("commission >= 0 AND commission <= amount", name="ck_trips_commission"),
        CheckConstraint("end_utc > start_utc", name="ck_trips_end_after_start"),
        CheckConstraint("payment IN ('cash', 'card')", name="ck_trips_payment"),
    )

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    start_utc: Mapped[dt.datetime] = mapped_column(DateTime)
    start_offset_min: Mapped[int] = mapped_column(Integer)
    end_utc: Mapped[dt.datetime] = mapped_column(DateTime)
    end_offset_min: Mapped[int] = mapped_column(Integer)
    local_date: Mapped[dt.date] = mapped_column(Date, index=True)
    amount: Mapped[int] = mapped_column(Integer)
    payment: Mapped[str] = mapped_column(String(8))
    commission: Mapped[int] = mapped_column(Integer)
