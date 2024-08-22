from pydantic import BaseModel, EmailStr


class UserPublicSchema(BaseModel):
    id: int
    username: str
    email: EmailStr


class UserSchema(UserPublicSchema):
    password: str
