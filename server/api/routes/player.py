from fastapi import APIRouter
from ..schemas.player_schemas import UserPublicSchema, UserSchema
from ..controllers import player_controller


router = APIRouter()


HTTPStatus = {"CREATED": 201}


@router.get("/players/")
async def read_players():
    return player_controller.read_all_players()


@router.post(
    "/players/",
    status_code=HTTPStatus["CREATED"],
    response_model=UserPublicSchema,
)
async def create_player(player: UserSchema):
    return player_controller.create_player(player)
