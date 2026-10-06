from unittest.mock import patch

from app.extensions import db


def test_health_returns_ok(client):
    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json() == {"status": "ok", "database": "ok"}


def test_health_returns_503_when_database_is_down(client):
    with patch.object(db.session, "execute", side_effect=Exception("db down")):
        response = client.get("/health")

    assert response.status_code == 503
    assert response.get_json() == {"status": "error", "database": "unreachable"}
