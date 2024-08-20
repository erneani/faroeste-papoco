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


def create_player(player: Player):
    player_dict = player.dict()

    existing_players = read_all_players()

    validation_errors = validate_player_creation(player_dict, existing_players)

    if not validation_errors:
        insert_player(player)
    
    return "Criado" if not validation_errors else validation_errors


def validate_player_creation(player: Player, existing_players: list[Player]):
    existing_emails = [existing_player['email'] for existing_player in existing_players]
    existing_usernames = [existing_player['username'] for existing_player in existing_players]

    validation_errors = []

    if player['email'] in existing_emails:
        validation_errors.append("O email já existe")
    
    if player['username'] in existing_usernames:
        validation_errors.append("O nome de usuário já existe")

    return validation_errors


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
