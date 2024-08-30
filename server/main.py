"""
Server main file. Instantiates the App and server.
"""

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from api.routes import matchs, players
from database import create_db

app = FastAPI()

create_db()


class ConnectionManager:
    def __init__(self):
        self.active_connections: list[any] = []
        self.players: list[str] = []
        self.matchs: list[any] = []

    async def connect(self, websocket: WebSocket, type: str):
        await websocket.accept()
        self.active_connections.append({"socket": websocket, "type": type})

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    def insert_player(self, new_player: str):
        self.players.append(new_player)

    def insert_match(self, match_description):
        match_props = match_description.split(" | ")

        myMatch = {
            "name": match_props[0],
            "created_by": match_props[1],
            "players": [match_props[1]],
            "description": match_description,
        }

        self.matchs.append(myMatch)

    async def broadcast(self, message: str, type: str):
        filtered_connections = [
            connection["socket"]
            for connection in self.active_connections
            if connection["type"] == type
        ]

        for connection in filtered_connections:
            await connection.send_text(message)


manager = ConnectionManager()


@app.get("/")
async def root():
    return {"message": "hello world"}


@app.websocket("/ws/players")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket, "player")

    try:
        while True:
            data = await websocket.receive_text()

            if data:
                manager.insert_player(data)
                for player in manager.players:
                    await manager.broadcast(player, "player")

                await manager.broadcast("end", "player")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        await manager.broadcast(f"player left the chat")


@app.websocket("/ws/messages")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket, "message")

    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(data, "message")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        await manager.broadcast(f"player left the chat")


@app.websocket("/ws/matchs")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket, "match")

    try:
        while True:
            data = await websocket.receive_text()

            if data:
                manager.insert_match(data)

                for match in manager.matchs:
                    await manager.broadcast(match["description"], "match")

                await manager.broadcast("end", "match")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        await manager.broadcast(f"player left the chat")


app.include_router(players.router)
app.include_router(matchs.router)
