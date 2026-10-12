from typing import Annotated

from pydantic import (
    AwareDatetime,
    BaseModel,
    ConfigDict,
    Field,
    ValidationInfo,
    WithJsonSchema,
    field_validator,
)

from app.schemas.payment import PaymentMethod

# В OpenAPI момент времени описан как строка, а не `format: date-time`: Dart-генератор клиента
# превратил бы её в DateTime и потерял смещение пояса (+05:00), по которому считается день поездки.
IsoDateTime = Annotated[
    AwareDatetime,
    WithJsonSchema(
        {
            "type": "string",
            "examples": ["2026-10-01T08:10:00+05:00"],
        }
    ),
]


class TripCreate(BaseModel):
    """Тело POST /trips. `id` задаёт клиент — он же служит ключом идемпотентности."""

    model_config = ConfigDict(extra="forbid")

    id: str = Field(
        min_length=1,
        max_length=64,
        pattern=r"^[A-Za-z0-9_.:-]+$",
        description="Уникальный идентификатор. Повторная отправка с тем же id не создаёт дубль.",
        examples=["t1"],
    )
    start: IsoDateTime = Field(description="Начало поездки, ISO 8601 со смещением пояса")
    end: IsoDateTime = Field(description="Окончание поездки, ISO 8601, строго позже начала")
    amount: int = Field(gt=0, description="Сумма поездки, целое число больше нуля")
    payment: PaymentMethod
    commission: int = Field(ge=0, description="Комиссия, от 0 до суммы поездки включительно")

    # Порядок полей важен: к моменту проверки end/commission start/amount уже разобраны.
    @field_validator("end")
    @classmethod
    def end_after_start(cls, end: AwareDatetime, info: ValidationInfo) -> AwareDatetime:
        start = info.data.get("start")
        if start is not None and end <= start:
            raise ValueError("Окончание поездки должно быть позже начала")
        return end

    @field_validator("commission")
    @classmethod
    def commission_within_amount(cls, commission: int, info: ValidationInfo) -> int:
        amount = info.data.get("amount")
        if amount is not None and commission > amount:
            raise ValueError("Комиссия не может превышать сумму поездки")
        return commission


class Trip(TripCreate):
    """Поездка в ответах API."""

    model_config = ConfigDict(extra="ignore")
