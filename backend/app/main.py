"""
Simple FastAPI app with /api/v1 routes: Swagger, info, healthcheck, calc,
subtract, datetime. Exposes /metrics for Prometheus.
"""
import platform
import sys
from datetime import datetime, timezone
from typing import Any

from fastapi import APIRouter, FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(
    title="Demo API",
    version="1.0.0",
    docs_url="/api/v1",
    openapi_url="/api/v1/openapi.json",
)

Instrumentator().instrument(app).expose(app, endpoint="/metrics")

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


@router.get("/datetime")
def datetime_now() -> dict[str, str]:
    """Return current date and time (UTC)."""
    now = datetime.now(timezone.utc)
    return {
        "date": now.strftime("%Y-%m-%d"),
        "time": now.strftime("%H:%M:%S"),
        "datetime_iso": now.isoformat(),
    }


@router.get("/calc/{a}/{b}")
def calc(a: float, b: float) -> dict[str, float]:
    """Add two numbers a and b."""
    return {"result": a + b}


@router.get("/subtract/{a}/{b}")
def subtract(a: float, b: float) -> dict[str, float]:
    """Subtract b from a."""
    return {"result": a - b}


app.include_router(router)
