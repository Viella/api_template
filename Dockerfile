FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_SYSTEM_PYTHON=1 \
    UV_LINK_MODE=copy

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/uv

WORKDIR /app

# Copy dependency definitions first for better build caching
COPY pyproject.toml /app/

# Install dependencies into a local virtualenv
RUN uv sync --no-dev

# Copy application source
COPY src /app/src

EXPOSE 8000

# Use uv to run without syncing again (deps are already installed)
CMD ["uv", "run", "--no-sync", "uvicorn", "--app-dir", "src", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]


