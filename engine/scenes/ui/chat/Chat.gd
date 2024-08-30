extends VBoxContainer

# The URL we will connect to.
@export var websocket_url = "ws://localhost:8000/ws/messages"

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()
var players = []
var chat_username


func _on_send_button_pressed():
	socket.send_text(str(chat_username, ": ", $HBoxContainer/TextInput.text, "\n"))
	clear_text_input()


func _on_text_input_text_submitted(new_text):
	socket.send_text(str(chat_username, ": ", new_text, "\n"))
	clear_text_input()


# Helper functions
func clear_text_input():
	$HBoxContainer/TextInput.text = ''


func _on_control_user_populated(username):
	chat_username = username


func _process(_delta):
	if not chat_username:
		return

	# Call this in _process or _physics_process. Data transfer and state updates
	# will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	# WebSocketPeer.STATE_OPEN means the socket is connected and ready
	# to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var message = socket.get_packet().get_string_from_utf8()

			$MessagesOutput.text += message
			$MessagesOutput.scroll_vertical = INF

	# WebSocketPeer.STATE_CLOSING means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.


func _on_lobby_user_authorized(new_username):
	chat_username = new_username

	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		# Wait for the socket to connect.
		await get_tree().create_timer(2).timeout

		# Send data.
		socket.send_text(str(new_username, " acabou de entrar no Chat!\n"))
