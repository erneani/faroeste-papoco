import uuid
from fastapi import APIRouter, HTTPException
from sqlalchemy import insert
from sqlmodel import Session, select
from database import engine
from api.models import Match


router = APIRouter()


@router.get("/matchs/")
def read_matchs():
    with Session(engine) as session:
        all_matchs = session.exec(select(Match)).all()

        return all_matchs


@router.post("/matchs/")
def create_match(match: Match):
    with Session(engine) as session:
        already_created_match = session.exec(
            select(Match).where(Match.created_by == match.created_by)
        ).first()

        if already_created_match:
            return HTTPException(status_code=400, detail="Player already have a match")

        match.id = str(uuid.uuid4())

        session.add(match)
        session.commit()

        return match


@router.delete("/matchs/{match_id}")
def delete_match(match_id: str):
    with Session(engine) as session:
        match = session.exec(select(Match).where(Match.id == match_id)).first()

        if not match:
            return HTTPException(status_code=400, detail="Match do not exist")

        session.delete(match)
        session.commit()

        return match
