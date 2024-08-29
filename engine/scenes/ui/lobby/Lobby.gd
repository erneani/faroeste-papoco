extends MarginContainer

var username

signal user_authorized

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
	user_authorized.emit(new_username)
