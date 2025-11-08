def test_root_message(client):
    response = client.get("/")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, dict)
    assert "message" in body


