# Backend — Driver Diary API

FastAPI + SQLAlchemy 2.0 (SQLite). Подробное описание проекта — в [корневом README](../README.md).

## Запуск

PowerShell (Windows):

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -e ".[dev]"
Copy-Item .env.example .env          # необязательно
uvicorn app.main:app --reload
```

bash (Linux / macOS / Git Bash):

```bash
python -m venv .venv
source .venv/bin/activate            # Git Bash на Windows: source .venv/Scripts/activate
pip install -e ".[dev]"
cp .env.example .env                 # необязательно
uvicorn app.main:app --reload
```

Swagger UI: http://localhost:8000/docs.

## Тесты и утилиты

```bash
pytest --cov=app                     # тесты и покрытие
ruff check . && ruff format --check .
python scripts/export_openapi.py     # обновить ../client/swaggers/driver_diary.json
```
