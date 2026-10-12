"""Выгружает OpenAPI-схему в клиент для генерации Dart-кода.

Запуск из backend/:  python scripts/export_openapi.py [путь/к/файлу.json]
"""

import json
import sys
from pathlib import Path

from app.core.config import BACKEND_DIR, Settings
from app.main import create_app

DEFAULT_TARGET = BACKEND_DIR.parent / "client" / "swaggers" / "driver_diary.json"


def main() -> None:
    target = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_TARGET
    # БД и seed схеме не нужны — берём изолированные настройки.
    settings = Settings(_env_file=None, database_url="sqlite://", seed_on_start=False)
    schema = create_app(settings).openapi()

    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(
        json.dumps(schema, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print(f"OpenAPI {schema['openapi']} -> {target}")


if __name__ == "__main__":
    main()
