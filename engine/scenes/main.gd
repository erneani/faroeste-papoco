extends Control

signal user_populated

var username = ""

func _on_login_login_authorized(username):
	$MainMenu.visible = false
	$Lobby.visible = true
	username = username
	user_populated.emit(username)
