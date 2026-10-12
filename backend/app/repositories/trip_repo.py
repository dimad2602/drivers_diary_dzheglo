import datetime as dt

from sqlalchemy import func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.db.models import TripRow
from app.schemas.trip import Trip, TripCreate


class DuplicateTripError(Exception):
    """Поездка с таким id уже есть."""

    def __init__(self, trip_id: str) -> None:
        super().__init__(f"Поездка {trip_id!r} уже существует")
        self.trip_id = trip_id


def _offset_minutes(value: dt.datetime) -> int:
    offset = value.utcoffset()
    assert offset is not None  # AwareDatetime гарантирует наличие пояса
    return round(offset.total_seconds() / 60)


def _to_utc_naive(value: dt.datetime) -> dt.datetime:
    return value.astimezone(dt.UTC).replace(tzinfo=None)


def _from_utc_naive(value: dt.datetime, offset_min: int) -> dt.datetime:
    tz = dt.timezone(dt.timedelta(minutes=offset_min))
    return value.replace(tzinfo=dt.UTC).astimezone(tz)


def _to_row(data: TripCreate) -> TripRow:
    return TripRow(
        id=data.id,
        start_utc=_to_utc_naive(data.start),
        start_offset_min=_offset_minutes(data.start),
        end_utc=_to_utc_naive(data.end),
        end_offset_min=_offset_minutes(data.end),
        local_date=data.start.date(),  # дата в поясе самой поездки, не в UTC
        amount=data.amount,
        payment=data.payment.value,
        commission=data.commission,
    )


def _to_schema(row: TripRow) -> Trip:
    return Trip(
        id=row.id,
        start=_from_utc_naive(row.start_utc, row.start_offset_min),
        end=_from_utc_naive(row.end_utc, row.end_offset_min),
        amount=row.amount,
        payment=row.payment,
        commission=row.commission,
    )


class TripRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def get(self, trip_id: str) -> Trip | None:
        row = self._session.get(TripRow, trip_id)
        return _to_schema(row) if row else None

    def count(self) -> int:
        return self._session.scalar(select(func.count()).select_from(TripRow)) or 0

    def list_by_date(self, day: dt.date) -> list[Trip]:
        rows = self._session.scalars(
            select(TripRow).where(TripRow.local_date == day).order_by(TripRow.start_utc, TripRow.id)
        )
        return [_to_schema(row) for row in rows]

    def add(self, data: TripCreate) -> Trip:
        """Сохраняет поездку. Уникальность гарантирует PRIMARY KEY, а не предварительный get()."""
        row = _to_row(data)
        self._session.add(row)
        try:
            self._session.commit()
        except IntegrityError:
            self._session.rollback()
            # Нарушение может быть и не по id (CHECK) — тогда это не дубль, пробрасываем как есть.
            if self._session.get(TripRow, data.id) is not None:
                raise DuplicateTripError(data.id) from None
            raise
        return _to_schema(row)
