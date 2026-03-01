"""
Simple FastAPI app with /api/v1 routes: Swagger, info, healthcheck, calc.
"""
import platform
import sys
from typing import Any

from fastapi import APIRouter, FastAPI

app = FastAPI(
    title="Demo API",
    version="1.0.0",
    docs_url="/api/v1",
    openapi_url="/api/v1/openapi.json",
)

router = APIRouter(prefix="/api/v1", tags=["api v1"])


@router.get("/info")
def info() -> dict[str, Any]:
    """Return system information."""
    return {
        "python_version": sys.version,
        "platform": platform.platform(),
        "processor": platform.processor() or "N/A",
    }


@router.get("/healthcheck")
def healthcheck() -> dict[str, str]:
    """Health check endpoint."""
    return {"status": "ok"}


@router.get("/calc/{a}/{b}")
def calc(a: float, b: float) -> dict[str, float]:
    """Add two numbers a and b."""
    return {"result": a + b}


app.include_router(router)
