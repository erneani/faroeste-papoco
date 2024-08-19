'''
Server main file. Instantiates the App and server.
'''
from fastapi import FastAPI
from api.routes.player import router

app = FastAPI()

@app.get('/')
async def root():
    return {"message": "hello world"}

app.include_router(router)
