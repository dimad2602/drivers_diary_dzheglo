from sqlalchemy import Engine, create_engine
from sqlalchemy.engine import make_url
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import StaticPool


def create_db_engine(url: str) -> Engine:
    """Движок для SQLite: запросы FastAPI идут из пула потоков, поэтому check_same_thread=False."""
    kwargs: dict = {"connect_args": {"check_same_thread": False}}
    if make_url(url).database in (None, "", ":memory:"):
        # In-memory БД живёт на одном соединении — иначе каждый поток увидит пустую базу.
        kwargs["poolclass"] = StaticPool
    return create_engine(url, **kwargs)


def create_session_factory(engine: Engine) -> sessionmaker[Session]:
    return sessionmaker(engine, expire_on_commit=False)
