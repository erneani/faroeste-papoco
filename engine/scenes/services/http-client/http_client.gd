extends HTTPRequest

var base_url = 'http://localhost:8000'

var players_url = '/players/'
var matchs_url = '/matchs/'


func get_matchs():
	return base_url + matchs_url
