"""Схема OpenAPI — контракт для генератора Dart-клиента: следим, чтобы она не «поплыла»."""

import json

from fastapi.testclient import TestClient


def _schema(client: TestClient) -> dict:
    return client.get("/openapi.json").json()


def test_operation_ids_are_stable(client: TestClient):
    operations = {
        (path, method): op["operationId"]
        for path, methods in _schema(client)["paths"].items()
        for method, op in methods.items()
    }

    assert operations == {
        ("/api/v1/trips", "get"): "listTrips",
        ("/api/v1/trips", "post"): "createTrip",
        ("/api/v1/summary", "get"): "getDaySummary",
    }


def test_create_trip_documents_all_outcomes(client: TestClient):
    responses = _schema(client)["paths"]["/api/v1/trips"]["post"]["responses"]

    assert set(responses) == {"200", "201", "401", "409", "422"}


def test_domain_schemas_have_no_nullable_fields(client: TestClient):
    # Nullable-поля превращаются в dynamic в сгенерированном Dart-коде.
    schemas = _schema(client)["components"]["schemas"]

    for name in ("Trip", "TripCreate", "DaySummary", "PaymentBreakdown", "ByPayment"):
        assert "null" not in json.dumps(schemas[name]), name
        assert "anyOf" not in json.dumps(schemas[name]), name


def test_all_fields_of_domain_schemas_are_required(client: TestClient):
    schemas = _schema(client)["components"]["schemas"]

    for name in ("Trip", "TripCreate", "DaySummary", "PaymentBreakdown", "ByPayment"):
        assert set(schemas[name]["required"]) == set(schemas[name]["properties"]), name
