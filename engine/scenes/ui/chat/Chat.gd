extends VBoxContainer


func _on_tree_entered():
	var peer = ENetMultiplayerPeer.new()
	
	peer.create_client("127.0.0.1", 1027)
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	
	multiplayer.multiplayer_peer = peer

func _on_send_button_pressed():
	rpc("msg_rpc", $HBoxContainer/TextInput.text)

@rpc ("any_peer", "call_local")
func msg_rpc(message):
	clear_text_input()
	$MessagesOutput.text += str(message, "\n")
	$MessagesOutput.scroll_vertical = INF

# Helper functions
func clear_text_input():
	$HBoxContainer/TextInput.text = ''
