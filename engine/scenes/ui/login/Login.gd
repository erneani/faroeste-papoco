extends VBoxContainer

var username = ""
var password


# helper functions
func enable_button():
	if (password and username):
		$Button.disabled = false
	else:
		$Button.disabled = true

# signals
func _on_username_input_text_changed(new_text):
	username = $UsernameInput.text
	enable_button()

func _on_password_input_text_changed(new_text):
	password = $PasswordInput.text.sha256_text()
	enable_button()
