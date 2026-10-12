from functools import lru_cache
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict

BACKEND_DIR = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BACKEND_DIR / ".env", extra="ignore")

    database_url: str = f"sqlite:///{(BACKEND_DIR / 'driver_diary.db').as_posix()}"
    # Пустой ключ отключает проверку X-API-Key — удобно для локальной отладки.
    api_key: str = ""
    seed_on_start: bool = True
    seed_file: Path = BACKEND_DIR / "data" / "trips.json"


@lru_cache
def get_settings() -> Settings:
    return Settings()
