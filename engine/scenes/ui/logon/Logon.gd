extends VBoxContainer

signal user_created

var request_url = 'http://localhost:8000/players/'
var username = ""
var password
var email = ""

func _on_password_input_text_changed(new_text):
	password = new_text
	enable_button()

func _on_username_input_text_changed(new_text):
	username = new_text
	enable_button()

func _on_button_pressed():
	var json = JSON.stringify({ "username": username, "password": password, "email": email })
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(request_url, headers, HTTPClient.METHOD_POST, json)

# helper functions
func enable_button():
	if (username and password):
		$Button.disabled = false


func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		$AcceptDialog.title = "Usuário criado"
		$AcceptDialog.dialog_text = "Seu usuário foi criado corretamente."
		$AcceptDialog.visible = true
		user_created.emit()
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	$AcceptDialog.title = "Erro na criação"
	$AcceptDialog.dialog_text = json["detail"]
	$AcceptDialog.visible = true


func _on_line_edit_text_changed(new_text):
	email = new_text
