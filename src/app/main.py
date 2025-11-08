from fastapi import FastAPI

from . import __version__

# 最小構成で、Routerは存在しない

# init で定義した __version__を使用してOpenAPIで表示可能
app = FastAPI(title="API Template", version=__version__)

@app.get("/", tags=["root"])
def read_root() -> dict[str, str]:
    return {"message": "Hello from FastAPI + uv template"}


@app.get("/health", tags=["health"])
def health() -> dict[str, str]:
    return {"status": "ok"}

# tags: グループ化されたAPIを表示するためのグループ名 OpenAPI用
@app.post("/posting_api",tags=["posting_api"])
def posting_test(string:str):
    return {"message": "Oh yeah"}

@app.post("/posting_api/2",tags=["posting_api"])
def posting_test_2(string:str):
    return {"message": "Oh"}
