from sqlmodel import create_engine, SQLModel
from api.models import Match, Player

sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

engine = create_engine(sqlite_url, echo=True)


def create_db():
    SQLModel.metadata.create_all(engine)


if __name__ == "__main__":
    create_db()
