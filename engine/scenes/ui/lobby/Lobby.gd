extends MarginContainer

var username

func _on_ready():
	var peer = ENetMultiplayerPeer.new()
	
	peer.create_server(1027)
	
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	
	multiplayer.multiplayer_peer = peer


func _on_create_button_pressed():
	create_match($HBoxContainer/HBoxContainer/Matchs/HBoxContainer/MatchInput.text)


func _on_match_input_text_submitted(new_text):
	create_match(new_text)


func clear_match_input():
	$HBoxContainer/HBoxContainer/Matchs/HBoxContainer/MatchInput.text = ''


# create things
func create_match(text):
	print(text)
	clear_match_input()


func _on_control_user_populated(new_username):
	username = new_username
