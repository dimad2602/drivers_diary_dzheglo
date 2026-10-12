import datetime as dt
from collections.abc import Iterable
from dataclasses import dataclass

from app.schemas.payment import PaymentMethod
from app.schemas.summary import ByPayment, DaySummary, PaymentBreakdown
from app.schemas.trip import Trip


@dataclass
class _Totals:
    trips_count: int = 0
    revenue: int = 0
    commission: int = 0

    def to_breakdown(self) -> PaymentBreakdown:
        return PaymentBreakdown(
            trips_count=self.trips_count,
            revenue=self.revenue,
            commission=self.commission,
            net=self.revenue - self.commission,
        )


def calculate_summary(day: dt.date, trips: Iterable[Trip]) -> DaySummary:
    """Сводка за день по уже отобранным поездкам. Фильтрацию по дню делает вызывающий код.

    «На руки» = выручка − комиссия.
    """
    totals = {method: _Totals() for method in PaymentMethod}
    for trip in trips:
        bucket = totals[trip.payment]
        bucket.trips_count += 1
        bucket.revenue += trip.amount
        bucket.commission += trip.commission

    cash = totals[PaymentMethod.CASH].to_breakdown()
    card = totals[PaymentMethod.CARD].to_breakdown()
    return DaySummary(
        date=day,
        trips_count=cash.trips_count + card.trips_count,
        revenue=cash.revenue + card.revenue,
        commission=cash.commission + card.commission,
        net=cash.net + card.net,
        by_payment=ByPayment(cash=cash, card=card),
    )
