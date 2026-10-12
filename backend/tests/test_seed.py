import json
import logging
from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from app.core.config import BACKEND_DIR, Settings
from app.main import create_app
from tests.factories import trip_payload

SEED_FILE = BACKEND_DIR / "data" / "trips.json"


def _settings(tmp_path: Path, **overrides) -> Settings:
    values = {
        "database_url": f"sqlite:///{(tmp_path / 'seed.db').as_posix()}",
        "seed_on_start": True,
        "seed_file": SEED_FILE,
    }
    return Settings(_env_file=None, **{**values, **overrides})


def _summary(client: TestClient, day: str) -> dict:
    return client.get("/api/v1/summary", params={"date": day}).json()


def test_seed_file_is_valid_and_has_assignment_example():
    payloads = json.loads(SEED_FILE.read_text(encoding="utf-8"))

    assert len({p["id"] for p in payloads}) == len(payloads)
    assert {"t1", "t2"} <= {p["id"] for p in payloads}


def test_seed_loads_trips_on_first_start(tmp_path):
    with TestClient(create_app(_settings(tmp_path))) as client:
        summary = _summary(client, "2026-10-01")

    assert (summary["trips_count"], summary["revenue"], summary["net"]) == (2, 3900, 3315)


def test_restart_does_not_duplicate_seed(tmp_path):
    settings = _settings(tmp_path)
    with TestClient(create_app(settings)) as client:
        first = _summary(client, "2026-10-01")
    with TestClient(create_app(settings)) as client:
        second = _summary(client, "2026-10-01")

    assert first == second


def test_seed_does_not_touch_non_empty_database(tmp_path):
    settings = _settings(tmp_path, seed_on_start=False)
    with TestClient(create_app(settings)) as client:
        client.post("/api/v1/trips", json=trip_payload("mine"))

    with TestClient(create_app(_settings(tmp_path))) as client:
        trips = client.get("/api/v1/trips", params={"date": "2026-10-01"}).json()

    assert [t["id"] for t in trips] == ["mine"]


def test_seed_can_be_disabled(tmp_path):
    with TestClient(create_app(_settings(tmp_path, seed_on_start=False))) as client:
        assert _summary(client, "2026-10-01")["trips_count"] == 0


def test_missing_seed_file_does_not_break_startup(tmp_path, caplog):
    settings = _settings(tmp_path, seed_file=tmp_path / "absent.json")

    with caplog.at_level(logging.WARNING), TestClient(create_app(settings)) as client:
        assert _summary(client, "2026-10-01")["trips_count"] == 0

    assert "absent.json" in caplog.text


def test_invalid_seed_data_fails_loudly(tmp_path):
    bad = tmp_path / "bad.json"
    bad.write_text(json.dumps([trip_payload(amount=0, commission=0)]), encoding="utf-8")

    # pydantic.ValidationError наследует ValueError
    with (
        pytest.raises(ValueError),
        TestClient(create_app(_settings(tmp_path, seed_file=bad))),
    ):
        pass
