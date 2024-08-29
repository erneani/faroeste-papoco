extends VBoxContainer

var chat_username

func _ready():
	connect_to_multiplayer()

func _on_send_button_pressed():
	send_message()

func _on_text_input_text_submitted(new_text):
	send_message()

@rpc ("any_peer", "call_local")
func msg_rpc(message):
	clear_text_input()
	$MessagesOutput.text += str(chat_username, ': ', message, "\n")
	$MessagesOutput.scroll_vertical = INF

# Helper functions
func clear_text_input():
	$HBoxContainer/TextInput.text = ''

func send_message():
	rpc("msg_rpc", $HBoxContainer/TextInput.text)

func _on_control_user_populated(username):
	chat_username = username
	#connect_to_multiplayer()

func connect_to_multiplayer():
	print("creating new peer")
	var peer = ENetMultiplayerPeer.new()

	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = peer
