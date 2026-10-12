import secrets

from fastapi import HTTPException, Request, Security, status
from fastapi.security import APIKeyHeader

api_key_header = APIKeyHeader(
    name="X-API-Key",
    auto_error=False,
    description="Ключ доступа. Если на сервере `API_KEY` пуст, проверка отключена.",
)


def require_api_key(request: Request, provided: str | None = Security(api_key_header)) -> None:
    expected: str = request.app.state.settings.api_key
    if not expected:
        return
    if provided is None or not secrets.compare_digest(provided.encode(), expected.encode()):
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Неверный или отсутствующий API-ключ")
