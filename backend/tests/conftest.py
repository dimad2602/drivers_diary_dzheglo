from collections.abc import Iterator

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient

from app.core.config import Settings
from app.main import create_app

API_KEY = "test-key"


@pytest.fixture
def settings() -> Settings:
    # _env_file=None — тесты не должны зависеть от локального .env разработчика.
    return Settings(_env_file=None, database_url="sqlite://", api_key=API_KEY, seed_on_start=False)


@pytest.fixture
def app(settings: Settings) -> FastAPI:
    return create_app(settings)


@pytest.fixture
def client(app: FastAPI) -> Iterator[TestClient]:
    with TestClient(app, headers={"X-API-Key": API_KEY}) as test_client:
        yield test_client
