from pydantic import BaseModel
from typing import List


class MatchSchema(BaseModel):
    id: str
    player_amount: int
    created_by: str
    players_assigned: List[str]
    is_active: bool
