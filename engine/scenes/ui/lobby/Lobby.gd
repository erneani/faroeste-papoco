extends MarginContainer


func _on_ready():
	var peer = ENetMultiplayerPeer.new()
	
	peer.create_server(1027)
	
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	
	multiplayer.multiplayer_peer = peer
