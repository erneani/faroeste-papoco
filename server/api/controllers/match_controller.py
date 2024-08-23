from ..database import delete_record, read_records, insert_record
from ..schemas.match_schemas import MatchSchema
from fastapi import HTTPException

MATCHS_KEY = "matchs"


def read_all_matchs():
    return read_records(MATCHS_KEY)


def insert_match(match: MatchSchema):
    existing_matchs = read_all_matchs()

    validate(match.model_dump(), existing_matchs)
    insert_record(MATCHS_KEY, match.model_dump())

    return match


def delete_match(match_id: str):
    delete_record(MATCHS_KEY, match_id)


# Helper functions


def validate(match_dict, matchs):
    already_created_match = any(
        [match["created_by"] == match_dict["created_by"] for match in matchs]
    )

    if already_created_match:
        raise HTTPException(400, "O jogador já criou uma partida")
