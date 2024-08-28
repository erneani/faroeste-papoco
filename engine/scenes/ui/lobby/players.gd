extends VBoxContainer

func _on_tree_entered():
	var peer = ENetMultiplayerPeer.new()
	
	peer.create_client("127.0.0.1", 1027)
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	
	multiplayer.multiplayer_peer = peer


func _on_control_user_populated(new_username):
	rpc("add_player", new_username)


@rpc ("any_peer", "call_local")
func add_player(new_player):
	$PlayersList.add_item(new_player)
