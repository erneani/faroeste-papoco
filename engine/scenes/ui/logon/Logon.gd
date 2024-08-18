extends VBoxContainer

var username = ""
var password

func _on_password_input_text_changed(new_text):
	password = new_text.sha256_text()
	enable_button()

func _on_username_input_text_changed(new_text):
	username = new_text
	enable_button()

func _on_button_pressed():
	print(username, password)

# helper functions
func enable_button():
	if (username and password):
		$Button.disabled = false
