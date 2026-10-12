import datetime as dt

import pytest
from fastapi.testclient import TestClient

from tests.factories import ALMATY, trip_payload

START = dt.datetime(2026, 10, 1, 8, 10, tzinfo=ALMATY)


def _post(client: TestClient, payload: dict):
    return client.post("/api/v1/trips", json=payload)


def _error_locations(response) -> set[str]:
    return {".".join(str(p) for p in item["loc"][1:]) for item in response.json()["detail"]}


@pytest.mark.parametrize("amount", [0, -1, -2400])
def test_amount_must_be_positive(client: TestClient, amount):
    response = _post(client, trip_payload(amount=amount, commission=0))

    assert response.status_code == 422
    assert "amount" in _error_locations(response)


def test_amount_must_be_integer(client: TestClient):
    response = _post(client, trip_payload(amount=100.5, commission=0))

    assert response.status_code == 422


def test_end_must_be_after_start(client: TestClient):
    payload = trip_payload()
    payload["end"] = (START - dt.timedelta(minutes=1)).isoformat()

    response = _post(client, payload)

    assert response.status_code == 422
    assert "end" in _error_locations(response)


def test_end_equal_to_start_is_rejected(client: TestClient):
    payload = trip_payload()
    payload["end"] = payload["start"]

    assert _post(client, payload).status_code == 422


def test_end_just_after_start_is_accepted(client: TestClient):
    payload = trip_payload(minutes=0)
    payload["end"] = (START + dt.timedelta(seconds=1)).isoformat()

    assert _post(client, payload).status_code == 201


def test_end_is_compared_as_moment_not_as_wall_clock(client: TestClient):
    # 09:00+05:00 — это 04:00 UTC, а 08:00+00:00 — на четыре часа позже.
    payload = trip_payload()
    payload["start"] = "2026-10-01T09:00:00+05:00"
    payload["end"] = "2026-10-01T08:00:00+00:00"

    assert _post(client, payload).status_code == 201

    payload = trip_payload("t2")
    payload["start"] = "2026-10-01T09:00:00+00:00"
    payload["end"] = "2026-10-01T10:00:00+05:00"  # 05:00 UTC — раньше начала

    assert _post(client, payload).status_code == 422


@pytest.mark.parametrize("field", ["start", "end"])
def test_naive_datetime_is_rejected(client: TestClient, field):
    payload = trip_payload()
    payload[field] = payload[field][:19]  # без смещения часового пояса

    response = _post(client, payload)

    assert response.status_code == 422
    assert field in _error_locations(response)


def test_commission_cannot_be_negative(client: TestClient):
    assert _post(client, trip_payload(commission=-1)).status_code == 422


def test_commission_cannot_exceed_amount(client: TestClient):
    response = _post(client, trip_payload(amount=1000, commission=1001))

    assert response.status_code == 422
    assert "commission" in _error_locations(response)


def test_commission_equal_to_amount_is_accepted(client: TestClient):
    assert _post(client, trip_payload(amount=1000, commission=1000)).status_code == 201


def test_unknown_payment_method_is_rejected(client: TestClient):
    assert _post(client, trip_payload(payment="crypto")).status_code == 422


@pytest.mark.parametrize("bad_id", ["", " ", "a b", "x" * 65, "id/with/slash"])
def test_invalid_id_is_rejected(client: TestClient, bad_id):
    assert _post(client, trip_payload(bad_id)).status_code == 422


def test_unknown_fields_are_rejected(client: TestClient):
    payload = trip_payload()
    payload["tips"] = 100

    assert _post(client, payload).status_code == 422


@pytest.mark.parametrize("missing", ["id", "start", "end", "amount", "payment", "commission"])
def test_required_fields(client: TestClient, missing):
    payload = trip_payload()
    del payload[missing]

    response = _post(client, payload)

    assert response.status_code == 422
    assert missing in _error_locations(response)


def test_invalid_request_does_not_create_trip(client: TestClient):
    _post(client, trip_payload(amount=0, commission=0))

    assert client.get("/api/v1/trips", params={"date": "2026-10-01"}).json() == []
