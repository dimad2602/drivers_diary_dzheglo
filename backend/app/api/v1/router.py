from fastapi import APIRouter, Depends, status

from app.api.v1 import summary, trips
from app.core.security import require_api_key
from app.schemas.errors import ErrorResponse

api_router = APIRouter(
    prefix="/api/v1",
    dependencies=[Depends(require_api_key)],
    responses={status.HTTP_401_UNAUTHORIZED: {"model": ErrorResponse}},
)
api_router.include_router(trips.router)
api_router.include_router(summary.router)
