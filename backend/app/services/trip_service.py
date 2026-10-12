import datetime as dt
from typing import NamedTuple

from app.domain.summary import calculate_summary
from app.repositories.trip_repo import DuplicateTripError, TripRepository
from app.schemas.summary import DaySummary
from app.schemas.trip import Trip, TripCreate


class TripConflictError(Exception):
    """Поездка с таким id уже есть, но с другим содержимым."""

    def __init__(self, trip_id: str) -> None:
        super().__init__(f"Поездка {trip_id!r} уже существует с другими данными")
        self.trip_id = trip_id


class AddTripResult(NamedTuple):
    trip: Trip
    created: bool


class TripService:
    def __init__(self, repo: TripRepository) -> None:
        self._repo = repo

    def add_trip(self, data: TripCreate) -> AddTripResult:
        """Идемпотентно добавляет поездку: `id` — ключ идемпотентности.

        Повтор с тем же содержимым возвращает уже сохранённую поездку (`created=False`),
        тот же id с другим содержимым — `TripConflictError`.
        """
        existing = self._repo.get(data.id)
        if existing is not None:
            return self._resolve_duplicate(existing, data)
        try:
            return AddTripResult(self._repo.add(data), created=True)
        except DuplicateTripError:
            # Параллельный запрос успел вставить ту же поездку между get() и add().
            existing = self._repo.get(data.id)
            assert existing is not None
            return self._resolve_duplicate(existing, data)

    def list_trips(self, day: dt.date) -> list[Trip]:
        return self._repo.list_by_date(day)

    def get_summary(self, day: dt.date) -> DaySummary:
        return calculate_summary(day, self._repo.list_by_date(day))

    @staticmethod
    def _resolve_duplicate(existing: Trip, data: TripCreate) -> AddTripResult:
        # Aware-datetime сравниваются как моменты времени, поэтому один и тот же момент
        # в другом поясе считается той же поездкой.
        if existing.model_dump() != data.model_dump():
            raise TripConflictError(data.id)
        return AddTripResult(existing, created=False)
