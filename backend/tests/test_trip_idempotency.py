"""Защита от дублей: повторная отправка той же поездки не создаёт вторую запись."""

import datetime as dt
from collections.abc import Iterator
from concurrent.futures import ThreadPoolExecutor

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from sqlalchemy import Engine

from app.core.config import Settings
from app.db.base import Base
from app.db.session import create_db_engine, create_session_factory
from app.main import create_app
from app.repositories.trip_repo import TripRepository
from app.schemas.trip import Trip
from app.services.trip_service import TripConflictError, TripService
from tests.factories import ALMATY, make_create, trip_payload

DAY = "2026-10-01"


@pytest.fixture
def engine(settings: Settings) -> Iterator[Engine]:
    """Своя БД для тестов сервиса без HTTP; соединение закрывается после теста."""
    engine = create_db_engine(settings.database_url)
    Base.metadata.create_all(engine)
    yield engine
    engine.dispose()


def _count_trips(client: TestClient) -> int:
    return len(client.get("/api/v1/trips", params={"date": DAY}).json())


def test_first_post_creates_trip(client: TestClient):
    response = client.post("/api/v1/trips", json=trip_payload("t1"))

    assert response.status_code == 201
    assert response.json()["id"] == "t1"


def test_repeated_post_does_not_create_duplicate(client: TestClient):
    first = client.post("/api/v1/trips", json=trip_payload("t1"))
    second = client.post("/api/v1/trips", json=trip_payload("t1"))

    assert first.status_code == 201
    assert second.status_code == 200
    assert second.json() == first.json()
    assert _count_trips(client) == 1


def test_many_repeats_still_one_record(client: TestClient):
    statuses = [client.post("/api/v1/trips", json=trip_payload("t1")).status_code for _ in range(5)]

    assert statuses == [201, 200, 200, 200, 200]
    assert _count_trips(client) == 1


def test_duplicate_does_not_change_summary(client: TestClient):
    client.post("/api/v1/trips", json=trip_payload("t1", amount=2400, commission=360))
    client.post("/api/v1/trips", json=trip_payload("t1", amount=2400, commission=360))

    summary = client.get("/api/v1/summary", params={"date": DAY}).json()

    assert summary["trips_count"] == 1
    assert summary["revenue"] == 2400


@pytest.mark.parametrize(
    "change",
    [
        {"amount": 2500, "commission": 360},
        {"commission": 100},
        {"payment": "cash"},
        {"minutes": 40},
        {"start": dt.datetime(2026, 10, 1, 9, 0, tzinfo=ALMATY)},
    ],
)
def test_same_id_with_different_content_is_conflict(client: TestClient, change):
    original = client.post("/api/v1/trips", json=trip_payload("t1"))

    response = client.post("/api/v1/trips", json=trip_payload("t1", **change))

    assert response.status_code == 409
    stored = client.get("/api/v1/trips", params={"date": DAY}).json()
    assert stored == [original.json()]


def test_same_moment_in_other_timezone_is_the_same_trip(client: TestClient):
    first = client.post("/api/v1/trips", json=trip_payload("t1"))
    same_moment_utc = dt.datetime(2026, 10, 1, 8, 10, tzinfo=ALMATY).astimezone(dt.UTC)

    again = client.post("/api/v1/trips", json=trip_payload("t1", start=same_moment_utc))

    assert again.status_code == 200
    assert again.json() == first.json()  # вернулась исходная запись, с её поясом +05:00
    assert _count_trips(client) == 1


def test_different_ids_with_same_content_are_separate_trips(client: TestClient):
    client.post("/api/v1/trips", json=trip_payload("t1"))
    response = client.post("/api/v1/trips", json=trip_payload("t2"))

    assert response.status_code == 201
    assert _count_trips(client) == 2


def test_service_returns_created_flag(engine: Engine):
    with create_session_factory(engine)() as session:
        service = TripService(TripRepository(session))

        first = service.add_trip(make_create(id="t1"))
        second = service.add_trip(make_create(id="t1"))

        assert (first.created, second.created) == (True, False)
        assert first.trip == second.trip
        with pytest.raises(TripConflictError):
            service.add_trip(make_create(id="t1", amount=2500))


class _BlindRepository(TripRepository):
    """Репозиторий, у которого проверка существования «опаздывает».

    Имитирует гонку: другой запрос вставил поездку между get() и add().
    """

    def get(self, trip_id: str) -> Trip | None:
        if not getattr(self, "_blinded", False):
            self._blinded = True
            return None
        return super().get(trip_id)


def test_race_between_check_and_insert_is_resolved_by_primary_key(engine: Engine):
    factory = create_session_factory(engine)
    with factory() as session:
        TripService(TripRepository(session)).add_trip(make_create(id="t1"))

    with factory() as session:
        service = TripService(_BlindRepository(session))
        result = service.add_trip(make_create(id="t1"))

        assert result.created is False
        assert TripRepository(session).count() == 1


def test_concurrent_identical_requests_create_exactly_one_trip(tmp_path):
    settings = Settings(
        _env_file=None,
        database_url=f"sqlite:///{(tmp_path / 'race.db').as_posix()}",
        seed_on_start=False,
    )
    app: FastAPI = create_app(settings)
    payload = trip_payload("t-race")

    with TestClient(app) as client, ThreadPoolExecutor(max_workers=8) as pool:
        statuses = list(
            pool.map(lambda _: client.post("/api/v1/trips", json=payload).status_code, range(16))
        )
        stored = client.get("/api/v1/trips", params={"date": DAY}).json()

    assert statuses.count(201) == 1
    assert statuses.count(200) == 15
    assert len(stored) == 1
