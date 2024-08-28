extends VBoxContainer


var url = 'http://localhost:8000/matchs'

func _ready():
	$HTTPRequest.request(url)

func _on_http_request_request_completed(result, response_code, headers, body):
	var match_list = JSON.parse_string(body.get_string_from_utf8())
