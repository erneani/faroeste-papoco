import os
import json
from ..models import Player


DEFAULT_ENCODING = 'utf-8'
FILE_BASE_PATH = 'database/'
BREAKLINE_CHAR = '\n'

PLAYERS_FILE_PATH = FILE_BASE_PATH + 'players.json'

OPENING_METHODS = {
    'read': 'r',
    'write': 'w',
    'append': 'a'
}


def insert_player(player: Player):
    file_exists = os.path.exists(PLAYERS_FILE_PATH)

    opening_method = OPENING_METHODS['append'] if file_exists else OPENING_METHODS['write']

    with open(PLAYERS_FILE_PATH, opening_method, encoding=DEFAULT_ENCODING) as file:
        player_json = json.dumps(player.dict())

        file.write(player_json + BREAKLINE_CHAR)

        return True

    return False


def read_all_players():
    file_exists = os.path.exists(PLAYERS_FILE_PATH)

    if not file_exists:
        return []
    
    with open(PLAYERS_FILE_PATH, OPENING_METHODS['read'], encoding=DEFAULT_ENCODING) as file:
        players = []

        for line in file:
            player_dict = json.loads(line)
            players.append(player_dict)
        
        return players
