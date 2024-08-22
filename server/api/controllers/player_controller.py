from ..schemas.player_schemas import UserSchema
from ..database import insert_record, read_records
from fastapi import HTTPException


PLAYERS_KEY = "players"


def read_all_players():
    return read_records(PLAYERS_KEY)


def create_player(player: UserSchema):
    existing_players = read_all_players()

    validate_player_creation(player.model_dump, existing_players)
    insert_record(PLAYERS_KEY, player.model_dump)

    return player


# Helper functions


def validate_player_creation(player: UserSchema, existing_players: list[UserSchema]):
    existing_emails = [existing_player["email"] for existing_player in existing_players]
    existing_usernames = [
        existing_player["username"] for existing_player in existing_players
    ]

    validation_errors = []

    if player["email"] in existing_emails:
        validation_errors.append("O email já existe")

    if player["username"] in existing_usernames:
        validation_errors.append("O nome de usuário já existe")

    if validation_errors:
        raise HTTPException(status_code=400, detail=validation_errors)
