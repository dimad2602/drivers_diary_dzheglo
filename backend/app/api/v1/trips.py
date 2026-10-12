import datetime as dt
from typing import Annotated

from fastapi import APIRouter, HTTPException, Query, Response, status

from app.api.deps import TripServiceDep
from app.schemas.errors import ErrorResponse
from app.schemas.trip import Trip, TripCreate
from app.services.trip_service import TripConflictError

router = APIRouter(prefix="/trips", tags=["trips"])

DateQuery = Annotated[
    dt.date, Query(description="День в формате YYYY-MM-DD", examples=["2026-10-01"])
]


@router.get(
    "",
    operation_id="listTrips",
    summary="Поездки за день",
    response_model=list[Trip],
)
def list_trips(date: DateQuery, service: TripServiceDep) -> list[Trip]:
    """Поездки, начавшиеся в выбранный день по местному времени поездки, по возрастанию начала."""
    return service.list_trips(date)


@router.post(
    "",
    operation_id="createTrip",
    summary="Добавить поездку",
    response_model=Trip,
    status_code=status.HTTP_201_CREATED,
    response_description="Поездка создана",
    responses={
        status.HTTP_200_OK: {
            "model": Trip,
            "description": "Повтор той же поездки: дубль не создан, возвращена сохранённая",
        },
        status.HTTP_409_CONFLICT: {
            "model": ErrorResponse,
            "description": "Поездка с таким id уже есть, но с другими данными",
        },
    },
)
def create_trip(body: TripCreate, response: Response, service: TripServiceDep) -> Trip:
    """Идемпотентное добавление: `id` задаёт клиент и служит ключом идемпотентности."""
    try:
        result = service.add_trip(body)
    except TripConflictError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc)) from exc
    if not result.created:
        response.status_code = status.HTTP_200_OK
    return result.trip
