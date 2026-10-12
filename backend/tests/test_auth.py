from fastapi.testclient import TestClient

from app.core.config import Settings
from app.main import create_app
from tests.conftest import API_KEY
from tests.factories import trip_payload

PROTECTED = [
    ("GET", "/api/v1/trips?date=2026-10-01"),
    ("GET", "/api/v1/summary?date=2026-10-01"),
]


# Клиенты без `with`: lifespan уже запущен фикстурой `client`, а повторный shutdown
# сбросил бы in-memory БД.


def test_requests_without_key_are_rejected(app):
    anonymous = TestClient(app)

    for method, url in PROTECTED:
        assert anonymous.request(method, url).status_code == 401
    assert anonymous.post("/api/v1/trips", json=trip_payload()).status_code == 401


def test_wrong_key_is_rejected(app):
    intruder = TestClient(app, headers={"X-API-Key": "nope"})

    response = intruder.get("/api/v1/trips", params={"date": "2026-10-01"})

    assert response.status_code == 401
    assert "detail" in response.json()


def test_correct_key_is_accepted(client: TestClient):
    assert client.get("/api/v1/trips", params={"date": "2026-10-01"}).status_code == 200


def test_rejected_post_does_not_create_trip(app, client: TestClient):
    TestClient(app).post("/api/v1/trips", json=trip_payload())

    assert client.get("/api/v1/trips", params={"date": "2026-10-01"}).json() == []


def test_docs_health_and_schema_are_public(app):
    anonymous = TestClient(app)

    assert anonymous.get("/health").json() == {"status": "ok"}
    assert anonymous.get("/docs").status_code == 200
    assert anonymous.get("/openapi.json").status_code == 200


def test_empty_api_key_disables_authentication():
    settings = Settings(_env_file=None, database_url="sqlite://", api_key="", seed_on_start=False)

    with TestClient(create_app(settings)) as anonymous:
        assert anonymous.get("/api/v1/trips", params={"date": "2026-10-01"}).status_code == 200


def test_openapi_declares_api_key_scheme(client: TestClient):
    schema = client.get("/openapi.json").json()

    schemes = schema["components"]["securitySchemes"]
    assert any(s["type"] == "apiKey" and s["name"] == "X-API-Key" for s in schemes.values())
    assert API_KEY not in str(schema)
