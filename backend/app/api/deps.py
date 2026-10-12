from collections.abc import Iterator
from typing import Annotated

from fastapi import Depends, Request
from sqlalchemy.orm import Session

from app.repositories.trip_repo import TripRepository
from app.services.trip_service import TripService


def get_session(request: Request) -> Iterator[Session]:
    with request.app.state.session_factory() as session:
        yield session


def get_trip_service(session: Annotated[Session, Depends(get_session)]) -> TripService:
    return TripService(TripRepository(session))


TripServiceDep = Annotated[TripService, Depends(get_trip_service)]
