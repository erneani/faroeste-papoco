extends VBoxContainer

var base_url = 'http://localhost:8000/'
var matchs_url = base_url + 'matchs/'
var players_url = base_url + 'players/'

func _ready():
	$HTTPRequest.request(matchs_url)

func _on_http_request_request_completed(result, response_code, headers, body):
	var match_list = JSON.parse_string(body.get_string_from_utf8())
	
	for match in match_list:
		$ItemList.add_item(match.name)
