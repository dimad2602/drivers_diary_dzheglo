import datetime as dt

from pydantic import BaseModel, Field


class PaymentBreakdown(BaseModel):
    trips_count: int = Field(description="Число поездок")
    revenue: int = Field(description="Выручка (сумма поездок)")
    commission: int = Field(description="Комиссия")
    net: int = Field(description="На руки: выручка минус комиссия")


class ByPayment(BaseModel):
    """Разбивка по способу оплаты. Оба ключа есть всегда, даже если поездок не было."""

    cash: PaymentBreakdown
    card: PaymentBreakdown


class DaySummary(BaseModel):
    date: dt.date
    trips_count: int
    revenue: int
    commission: int
    net: int = Field(description="На руки: выручка минус комиссия")
    by_payment: ByPayment
