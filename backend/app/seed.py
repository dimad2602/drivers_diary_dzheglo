import json
import logging
from pathlib import Path

from sqlalchemy.orm import Session, sessionmaker

from app.repositories.trip_repo import TripRepository
from app.schemas.trip import TripCreate
from app.services.trip_service import TripService

logger = logging.getLogger(__name__)


def seed_if_empty(session_factory: sessionmaker[Session], seed_file: Path) -> int:
    """Загружает поездки из JSON в пустую БД. Возвращает число добавленных поездок."""
    if not seed_file.exists():
        logger.warning("Файл с поездками %s не найден, seed пропущен", seed_file)
        return 0

    with session_factory() as session:
        repo = TripRepository(session)
        if repo.count() > 0:
            return 0
        service = TripService(repo)
        payloads = json.loads(seed_file.read_text(encoding="utf-8"))
        created = sum(service.add_trip(TripCreate.model_validate(p)).created for p in payloads)

    logger.info("Загружено поездок из %s: %d", seed_file.name, created)
    return created
