from pydantic import BaseModel

class Player(BaseModel):
    email: str
    username: str
    password: str
