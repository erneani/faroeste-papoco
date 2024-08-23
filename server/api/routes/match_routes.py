from typing import List
from fastapi import APIRouter

from api.controllers.match_controller import insert_match, read_all_matchs, delete_match
from api.schemas.match_schemas import MatchSchema

match_router = APIRouter()


@match_router.get("/matchs/", response_model=List[MatchSchema], status_code=200)
def get_all_matchs():
    return read_all_matchs()


@match_router.post("/matchs/", response_model=MatchSchema, status_code=201)
def create_match(match: MatchSchema):
    return insert_match(match)


@match_router.delete("/matchs/{match_id}", status_code=200)
def remove_match(match_id: str):
    return delete_match(match_id)
