extends MarginContainer

var username

signal user_authorized

func _on_control_user_populated(new_username):
	username = new_username
	user_authorized.emit(new_username)
