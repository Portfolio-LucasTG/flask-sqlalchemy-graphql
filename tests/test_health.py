from http import HTTPStatus
from logging import getLogger
from unittest.mock import patch

from app.extensions import db

logger = getLogger(__name__)


def test_health_returns_ok(client):
    response = client.get("/health")

    assert response.status_code == HTTPStatus.OK
    assert response.get_json() == {
        "status": HTTPStatus.OK.phrase,
        "database": "ok",
    }


def test_health_returns_503_when_database_is_down(client):
    with patch.object(db.session, "execute", side_effect=Exception("db down")):
        response = client.get("/health")

    assert response.status_code == HTTPStatus.SERVICE_UNAVAILABLE
    assert response.get_json() == {
        "status": HTTPStatus.SERVICE_UNAVAILABLE.phrase,
        "database": "unreachable",
    }
