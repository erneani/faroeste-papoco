import uuid
from fastapi import APIRouter, HTTPException
from sqlmodel import Session, select
from api.models import Login, Player
from database import engine

router = APIRouter()


@router.get("/players/")
def read_players():
    with Session(engine) as session:
        players = session.exec(select(Player)).all()

        return players


@router.post("/players/")
def create_player(player: Player):
    with Session(engine) as session:
        player_with_email = session.exec(
            select(Player).where(Player.email == player.email)
        )

        if player_with_email.first():
            raise HTTPException(status_code=400, detail="Email exists")

        player_with_username = session.exec(
            select(Player).where(Player.username == player.username)
        )

        if player_with_username.first():
            raise HTTPException(status_code=400, detail="Username exists")

        player.id = str(uuid.uuid4())
        session.add(player)
        session.commit()

    return player


@router.post("/players/login")
def perform_login(login: Login):
    with Session(engine) as session:
        player = session.exec(
            select(Player).where(Player.username == login.username)
        ).first()

        if player.password == login.password:
            return player

        return HTTPException(status_code=400, detail="Password or Username incorrect.")
