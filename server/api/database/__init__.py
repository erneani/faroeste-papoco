import os
import json
from enum import Enum

DB_PATH = "database/database.json"

DEFAULT_ENCODING = "utf-8"


class OpeningMethods(Enum):
    READ = "r"
    WRITE = "w"
    APPEND = "a"


def init_db():
    file_exists = os.path.exists(DB_PATH)

    if file_exists:
        return

    with open(DB_PATH, OpeningMethods.WRITE.value, encoding=DEFAULT_ENCODING) as file:
        starting_boilerplate = {"matchs": [], "players": []}

        json.dump(starting_boilerplate, file)


def insert_record(key: str, record: any = None):
    if not record:
        raise "Invalid record"

    all_records = read_all_database()

    if key not in all_records:
        all_records[key] = [record]
    else:
        all_records[key].append(record)

    write_database(all_records)


def read_records(key: str = None):
    if not key:
        return []

    all_records = read_all_database()

    if key not in all_records:
        return []

    return all_records[key]


def read_record(key: str, record_id: str = None):
    if not record_id:
        raise "No Record ID"

    all_records = read_all_database()

    records = all_records[key]

    record = [r for r in records if r["id"] == record_id][0]

    return record


def delete_record(key: str, record_id: str = None):
    if not record_id:
        raise "No Record ID"

    all_records = read_all_database()

    records = all_records[key]

    all_records[key] = [r for r in records if r["id"] != record_id]

    write_database(all_records)


# utility functions


def read_all_database():
    with open(DB_PATH, OpeningMethods.READ.value, encoding=DEFAULT_ENCODING) as file:
        database = json.load(file)

        return database


def write_database(dict_database):
    with open(DB_PATH, OpeningMethods.WRITE.value, encoding=DEFAULT_ENCODING) as file:
        json.dump(dict_database, file)
