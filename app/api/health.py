from http import HTTPStatus

from flask import Blueprint, jsonify
from sqlalchemy import text

from app.extensions import db

health_bp = Blueprint("health", __name__)


@health_bp.get("/health")
def health():
    """Liveness/readiness check, including a database connection check."""
    try:
        db.session.execute(text("SELECT 1"))
    except Exception:
        return (
            jsonify(
                status=HTTPStatus.SERVICE_UNAVAILABLE.phrase,
                database="unreachable",
            ),
            HTTPStatus.SERVICE_UNAVAILABLE,
        )

    return jsonify(status=HTTPStatus.OK.phrase, database="ok"), HTTPStatus.OK
