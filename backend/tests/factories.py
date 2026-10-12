import datetime as dt

from app.schemas.payment import PaymentMethod
from app.schemas.trip import Trip, TripCreate

ALMATY = dt.timezone(dt.timedelta(hours=5))


def trip_payload(
    id: str = "t1",
    *,
    start: dt.datetime | None = None,
    minutes: int = 22,
    amount: int = 2400,
    payment: str = "card",
    commission: int = 360,
) -> dict:
    """Тело запроса POST /trips в виде словаря (как его отправит клиент)."""
    start = start or dt.datetime(2026, 10, 1, 8, 10, tzinfo=ALMATY)
    end = start + dt.timedelta(minutes=minutes)
    return {
        "id": id,
        "start": start.isoformat(),
        "end": end.isoformat(),
        "amount": amount,
        "payment": payment,
        "commission": commission,
    }


def make_create(**kwargs) -> TripCreate:
    return TripCreate.model_validate(trip_payload(**kwargs))


def make_trip(
    id: str = "t1",
    *,
    amount: int = 2400,
    payment: PaymentMethod | str = PaymentMethod.CARD,
    commission: int = 360,
    start: dt.datetime | None = None,
) -> Trip:
    return Trip.model_validate(
        trip_payload(id, start=start, amount=amount, payment=str(payment), commission=commission)
    )
