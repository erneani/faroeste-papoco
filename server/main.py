"""
Server main file. Instantiates the App and server.
"""

from fastapi import FastAPI
from api.routes import matchs, players
from database import create_db

app = FastAPI()

create_db()


@app.get("/")
async def root():
    return {"message": "hello world"}


app.include_router(players.router)
app.include_router(matchs.router)
