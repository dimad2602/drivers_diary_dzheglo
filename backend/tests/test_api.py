import datetime as dt

from fastapi.testclient import TestClient

from tests.factories import trip_payload


def _add(client: TestClient, id: str, start: str, minutes: int = 20, **kwargs) -> dict:
    payload = trip_payload(id, start=dt.datetime.fromisoformat(start), minutes=minutes, **kwargs)
    response = client.post("/api/v1/trips", json=payload)
    assert response.status_code == 201, response.text
    return response.json()


def _ids(client: TestClient, day: str) -> list[str]:
    return [t["id"] for t in client.get("/api/v1/trips", params={"date": day}).json()]


def test_trip_is_returned_with_original_utc_offset(client: TestClient):
    created = _add(client, "t1", "2026-10-01T08:10:00+05:00")

    assert created["start"] == "2026-10-01T08:10:00+05:00"
    assert created["end"] == "2026-10-01T08:30:00+05:00"
    assert client.get("/api/v1/trips", params={"date": "2026-10-01"}).json() == [created]


def test_trips_are_filtered_by_day(client: TestClient):
    _add(client, "mon", "2026-10-01T10:00:00+05:00")
    _add(client, "tue", "2026-10-02T10:00:00+05:00")

    assert _ids(client, "2026-10-01") == ["mon"]
    assert _ids(client, "2026-10-02") == ["tue"]
    assert _ids(client, "2026-10-03") == []


def test_trips_are_sorted_by_start(client: TestClient):
    _add(client, "late", "2026-10-01T18:00:00+05:00")
    _add(client, "early", "2026-10-01T07:00:00+05:00")
    _add(client, "noon", "2026-10-01T12:00:00+05:00")

    assert _ids(client, "2026-10-01") == ["early", "noon", "late"]


def test_trip_across_midnight_belongs_to_start_day(client: TestClient):
    _add(client, "night", "2026-10-01T23:50:00+05:00", minutes=40)

    assert _ids(client, "2026-10-01") == ["night"]
    assert _ids(client, "2026-10-02") == []


def test_day_is_taken_in_trips_own_timezone_not_utc(client: TestClient):
    # 00:30+05:00 — это 19:30 UTC предыдущего дня, но день поездки — 2 октября.
    _add(client, "early-morning", "2026-10-02T00:30:00+05:00")
    # 23:30-05:00 — это 04:30 UTC следующего дня, но день поездки — 1 октября.
    _add(client, "late-evening", "2026-10-01T23:30:00-05:00")

    assert _ids(client, "2026-10-02") == ["early-morning"]
    assert _ids(client, "2026-10-01") == ["late-evening"]


def test_summary_matches_assignment_example(client: TestClient):
    _add(
        client,
        "t1",
        "2026-10-01T08:10:00+05:00",
        minutes=22,
        amount=2400,
        payment="card",
        commission=360,
    )
    _add(
        client,
        "t2",
        "2026-10-01T09:05:00+05:00",
        minutes=15,
        amount=1500,
        payment="cash",
        commission=225,
    )

    response = client.get("/api/v1/summary", params={"date": "2026-10-01"})

    assert response.status_code == 200
    assert response.json() == {
        "date": "2026-10-01",
        "trips_count": 2,
        "revenue": 3900,
        "commission": 585,
        "net": 3315,
        "by_payment": {
            "cash": {"trips_count": 1, "revenue": 1500, "commission": 225, "net": 1275},
            "card": {"trips_count": 1, "revenue": 2400, "commission": 360, "net": 2040},
        },
    }


def test_summary_of_empty_day_is_zeroes(client: TestClient):
    body = client.get("/api/v1/summary", params={"date": "2026-10-05"}).json()

    assert body["trips_count"] == 0
    assert body["revenue"] == body["commission"] == body["net"] == 0
    assert set(body["by_payment"]) == {"cash", "card"}


def test_summary_only_counts_requested_day(client: TestClient):
    _add(client, "a", "2026-10-01T10:00:00+05:00", amount=1000, commission=100)
    _add(client, "b", "2026-10-02T10:00:00+05:00", amount=5000, commission=500)

    body = client.get("/api/v1/summary", params={"date": "2026-10-01"}).json()

    assert (body["trips_count"], body["revenue"]) == (1, 1000)


def test_summary_reflects_newly_added_trip(client: TestClient):
    before = client.get("/api/v1/summary", params={"date": "2026-10-01"}).json()
    _add(client, "t1", "2026-10-01T10:00:00+05:00", amount=1000, commission=150)
    after = client.get("/api/v1/summary", params={"date": "2026-10-01"}).json()

    assert before["trips_count"] == 0
    assert (after["trips_count"], after["net"]) == (1, 850)


def test_date_parameter_is_required_and_validated(client: TestClient):
    for path in ("/api/v1/trips", "/api/v1/summary"):
        assert client.get(path).status_code == 422
        assert client.get(path, params={"date": "not-a-date"}).status_code == 422
        assert client.get(path, params={"date": "2026-13-40"}).status_code == 422


def test_health_and_docs_are_available(client: TestClient):
    assert client.get("/health").json() == {"status": "ok"}
    assert client.get("/docs").status_code == 200
    assert client.get("/openapi.json").status_code == 200
