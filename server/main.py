'''
Server main file. Instantiates the App and server.
'''
from fastapi import FastAPI

app = FastAPI()


@app.get('/')
async def root():
    return {"message": "hello world"}
