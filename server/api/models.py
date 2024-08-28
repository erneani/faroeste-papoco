from sqlmodel import SQLModel, Field


class Match(SQLModel, table=True):
    id: str | None = Field(default=None, primary_key=True)
    player_amount: int = Field(default=0)
    created_by: str
    is_active: bool = Field(default=False)
    name: str


class Player(SQLModel, table=True):
    id: str | None = Field(default=None, primary_key=True)
    username: str = Field(unique=True)
    email: str = Field(unique=True)
    password: str


class Login(SQLModel):
    username: str
    password: str
