from fastapi import APIRouter

router = APIRouter()

@router.get("/players/")
async def read_players():
    return [{
        "username": "some",
        "password": "pw"
    }]

