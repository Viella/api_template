from fastapi import FastAPI

from . import __version__


app = FastAPI(title="API Template", version=__version__)


@app.get("/", tags=["root"])
def read_root() -> dict[str, str]:
    return {"message": "Hello from FastAPI + uv template"}


@app.get("/health", tags=["health"])
def health() -> dict[str, str]:
    return {"status": "ok"}


