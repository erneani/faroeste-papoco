from fastapi import APIRouter
from pydantic import BaseModel

from ..models import Player
from ..controllers import player_controller


router = APIRouter()

class Player(BaseModel):
    email: str
    username: str
    password: str


@router.get("/players/")
async def read_players():
    return player_controller.read_all_players()


@router.post("/players/")
async def create_player(player: Player) -> str:
    return player_controller.create_player(player)
