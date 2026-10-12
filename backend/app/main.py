from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.api.v1.router import api_router
from app.core.config import Settings, get_settings
from app.db.base import Base
from app.db.session import create_db_engine, create_session_factory
from app.seed import seed_if_empty

DESCRIPTION = """
API дневника смен водителя: поездки за выбранный день и сводка за день.

* `POST /trips` идемпотентен: `id` поездки задаёт клиент, повтор не создаёт дубль.
* День определяется по дате начала поездки в её собственном часовом поясе.
* «На руки» = выручка − комиссия.
"""


def create_app(settings: Settings | None = None) -> FastAPI:
    settings = settings or get_settings()
    engine = create_db_engine(settings.database_url)
    session_factory = create_session_factory(engine)

    @asynccontextmanager
    async def lifespan(_: FastAPI) -> AsyncIterator[None]:
        # Для мини-проекта миграции не нужны: схема создаётся при старте.
        Base.metadata.create_all(engine)
        if settings.seed_on_start:
            seed_if_empty(session_factory, settings.seed_file)
        yield
        engine.dispose()

    app = FastAPI(
        title="Driver Diary API",
        version="1.0.0",
        description=DESCRIPTION,
        lifespan=lifespan,
        openapi_tags=[
            {"name": "trips", "description": "Поездки водителя"},
            {"name": "summary", "description": "Сводка за день"},
        ],
        swagger_ui_parameters={"persistAuthorization": True},
    )
    app.state.settings = settings
    app.state.session_factory = session_factory
    app.include_router(api_router)

    @app.get("/health", include_in_schema=False)
    def health() -> dict[str, str]:
        return {"status": "ok"}

    return app


app = create_app()
