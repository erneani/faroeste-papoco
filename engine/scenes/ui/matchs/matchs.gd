extends VBoxContainer

# The URL we will connect to.
@export var websocket_url = "ws://localhost:8000/ws/matchs"

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()
var matchs = []
var match_username
var has_created_match = false
var latest_selected_item = null

func _process(_delta):
	if not match_username:
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
			var received_match = socket.get_packet().get_string_from_utf8()
			
			if received_match == "end":
				$VBoxContainer/Matches.clear()

				for saved_match in matchs:
					$VBoxContainer/Matches.add_item(saved_match)
			
				matchs = []
			elif received_match == "empty":
				$VBoxContainer/Matches.clear()
				$HBoxContainer/CreateButton.disabled = false
				matchs = []
			else:
				matchs.append(received_match)

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
	match_username = new_username

	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		# Wait for the socket to connect.
		await get_tree().create_timer(3).timeout


func _on_create_button_pressed():
	send_text($HBoxContainer/MatchInput.text)

func _on_match_input_text_submitted(new_text):
	send_text(new_text)

func send_text(text):
	var formated_text = str(text, " | ", match_username, " | 1 player")
	
	socket.send_text(formated_text)
	$HBoxContainer/MatchInput.clear()
	$HBoxContainer/CreateButton.disabled = true


func _on_matches_item_selected(index):
	latest_selected_item = index

	var selected_text = $VBoxContainer/Matches.get_item_text(index)
	
	var match_info = selected_text.split(" | ")
	
	if match_info[1] == match_username:
		$VBoxContainer/HBoxContainer/DeleteButton.disabled = false
		$VBoxContainer/HBoxContainer/JoinButton.disabled = true
		return

	$VBoxContainer/HBoxContainer/JoinButton.disabled = false
	$VBoxContainer/HBoxContainer/DeleteButton.disabled = true


func _on_delete_button_pressed():
	var match_to_delete = $VBoxContainer/Matches.get_item_text(latest_selected_item)
	
	socket.send_text(str("delete ", match_username))
	
	$VBoxContainer/HBoxContainer/DeleteButton.disabled = true
	
