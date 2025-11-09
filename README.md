## FastAPI + uv + Uvicorn テンプレート（src レイアウト）

### 何が入っているか
- **uv によるパッケージ管理**（`pyproject.toml` ベース）
- **FastAPI** の最小アプリ（`/` と `/health`）
- **Uvicorn**（将来的に **Gunicorn** + UvicornWorker へ拡張可能）
- **Dockerfile** によるコンテナ化
- **src レイアウト**
- **CI**（Ruff で Lint、Docker イメージのビルド）
- **docker-compose**（開発用の簡易起動）

### ディレクトリ構成

```text
.
├── .dockerignore
├── .gitignore
├── .github
│   └── workflows
│       └── ci.yml
├── Dockerfile
├── docker-compose.yml
├── README.md
├── pyproject.toml
└── src
    └── app
        ├── __init__.py
        └── main.py
```

---

### 前提
- Python 3.12+
- uv（未インストールの場合）

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

インストール後、`uv --version` で確認できます。

---

### セットアップ

依存関係をインストール（ローカルに `.venv` が作成されます）:

```bash
uv sync
```

---

### 開発サーバー起動

src レイアウトをそのまま使うため、`uvicorn` の `--app-dir` を指定します。

```bash
uv run uvicorn --app-dir src app.main:app --reload --host 0.0.0.0 --port 8000
```

- ブラウザ: `http://127.0.0.1:8000`
- ヘルスチェック: `http://127.0.0.1:8000/health`
- OpenAPI ドキュメント: `http://127.0.0.1:8000/docs`

---

### Docker ビルド/実行

```bash
# ビルド
docker build -t api-template .

# 起動
docker run --rm -p 8000:8000 api-template
```

コンテナ内では uv により依存関係をインストールし、以下のコマンドで起動します:

```bash
uv run --no-sync uvicorn --app-dir src app.main:app --host 0.0.0.0 --port 8000
```

---

### Docker Compose（開発用）

ホットリロード付きで起動（`src` をマウントし、`--reload` で監視）。

```bash
# Build + Run
docker compose up --build

# 停止
docker compose down
```

ブラウザ: `http://127.0.0.1:8000`

---

### 将来的な Gunicorn 運用例

本テンプレートでは Uvicorn の単体起動ですが、将来的に Gunicorn を使う場合は次のようにできます（参考）:

```bash
gunicorn -k uvicorn.workers.UvicornWorker -w 2 -b 0.0.0.0:8000 app.main:app --chdir src
```

Docker 化する場合は、`Dockerfile` に `gunicorn` を追加インストールし、`CMD` を上記に変更してください。

---

### メモ
- パッケージ管理は **uv**（`pyproject.toml`）で行います。ロックファイルを使いたい場合は `uv lock` を実行してください。
- src レイアウトのため、開発中は `--app-dir src`（または `PYTHONPATH=src`）を指定してモジュールを解決しています。
- Uvicorn: ASGI Server, FastAPI: ASGI Application (Starlette)