"""
このファイルはpytestの設定ファイルです。
pytestはこのファイルを読み込んでテストを実行します。
fixtureを自動で認識するためにはconftest.pyの名前が大事
"""
import pytest
from fastapi.testclient import TestClient
from app.main import app

# scopeはテストの実行範囲を指定する
# moduleはテストファイルごとに実行
# sessionはテストセッションごとに実行
# classはテストクラスごとに実行
# functionはテスト関数ごとに実行
# デフォルトはfunction
@pytest.fixture(scope="module")
def client() -> TestClient:
    # TestClientは内部でHTTP鯖を起動して通信を模倣するのでwithでリソース管理
    # （ASGI Serverの呼び出し部分を模倣してくれている）
    with TestClient(app) as c:
        yield c



