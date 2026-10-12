from fastapi import APIRouter

from app.api.deps import TripServiceDep
from app.api.v1.trips import DateQuery
from app.schemas.summary import DaySummary

router = APIRouter(prefix="/summary", tags=["summary"])


@router.get(
    "",
    operation_id="getDaySummary",
    summary="Сводка за день",
    response_model=DaySummary,
)
def get_day_summary(date: DateQuery, service: TripServiceDep) -> DaySummary:
    """Число поездок, выручка, комиссия, «на руки» (выручка − комиссия) и разбивка по оплате."""
    return service.get_summary(date)
