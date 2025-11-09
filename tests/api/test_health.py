# pytestは tests/conftest.pyのfixtureを同ディレクトリ配下の全テストで自動的に解決する
def test_health_ok(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


