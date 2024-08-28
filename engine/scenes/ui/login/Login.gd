extends VBoxContainer

signal login_authorized

var request_url = 'http://localhost:8000/players/login'
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


func _on_button_pressed():
	var json = JSON.stringify({ "username": username, "password": password })
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(request_url, headers, HTTPClient.METHOD_POST, json)


func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		$AcceptDialog.title = "Usuário Logado!"
		$AcceptDialog.dialog_text = "Usuário digitado corretamente, entrando..."
		$AcceptDialog.visible = true
		login_authorized.emit(username)
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	$AcceptDialog.title = "Erro no Login"
	$AcceptDialog.dialog_text = "Usuário ou Email incorretos"
	$AcceptDialog.visible = true
