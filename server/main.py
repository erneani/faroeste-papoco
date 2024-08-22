"""
Server main file. Instantiates the App and server.
"""

from fastapi import FastAPI
from api.routes.player import router
from api.database import init_db

app = FastAPI()
init_db()


@app.get("/")
async def root():
    return {"message": "hello world"}


app.include_router(router)
