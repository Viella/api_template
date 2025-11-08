# uv は環境構築だけにする（マルチステージビルド）
#　最終のステージだけがイメージに残る
# builder
FROM ghcr.io/astral-sh/uv:python3.12-bookworm AS builder
#astralのuvのPythonイメージを使用   
#公式のスリムpythonイメージでもおk

# コンテナの 作業ディレクトリを設定
WORKDIR /app

# 依存のみ先にコピー（ビルドキャッシュ最適化）
# README.md忘れがち(hatchlingが、ビルド時にPyprojectの実際のファイルの存在チェックするので必要)
COPY pyproject.toml README.md uv.lock* /app/

#--forozenは依存関係を固定　（uv.lockを使用)　--no-devはdev依存関係をインストールしない
RUN uv sync --frozen --no-dev

# アプリ本体
COPY src /app/src

# runtime
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# builderステージのイメージからvenvをコピー
COPY --from=builder /app/.venv /app/.venv

COPY --from=builder /app/src /app/src

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000
CMD ["uvicorn", "--app-dir", "src", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

# 最終的にbuilderステージは消えるから軽量　やったね
# マルチステージビルドにしない場合 1.5GBくらいになった　->この構成だと約250MB