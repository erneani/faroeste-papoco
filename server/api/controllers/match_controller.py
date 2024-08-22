from ..database import read_records, insert_record
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


# Helper functions


def validate(match_dict, matchs):
    already_created_match = any(
        [match.created == match_dict.created for match in matchs]
    )

    if already_created_match:
        raise HTTPException(400, "O jogador já criou uma partida")
