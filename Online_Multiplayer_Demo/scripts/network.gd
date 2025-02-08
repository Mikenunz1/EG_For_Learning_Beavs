extends Node

signal connection_failed
signal player_joined(peer_id: int)

var is_server = false
var rtc_peer := WebRTCMultiplayerPeer.new()
var room_code = ""
var pending_peers = {}

func _ready():
	print("Network node ready")
	rtc_peer.peer_connected.connect(_on_peer_connected)
	rtc_peer.peer_disconnected.connect(_on_peer_disconnected)
	
	if !has_node("ConnectionHandler"):
		var connection_handler = ConnectionHandler.new()
		connection_handler.name = "ConnectionHandler"
		add_child(connection_handler)
	
	$ConnectionHandler.connection_failed.connect(func(): emit_signal("connection_failed"))
	$ConnectionHandler.player_joined.connect(func(id): emit_signal("player_joined", id))
	
	# Initially hide character selection buttons
	var rock_button = get_node("../RockButton")
	var stick_button = get_node("../StickButton")
	if rock_button and stick_button:
		rock_button.text = "Rock"
		stick_button.text = "Stick"
		rock_button.visible = false
		stick_button.visible = false
		print("Character buttons hidden initially")

func host_game():
	room_code = str(randi() % 10000).pad_zeros(4)
	print("Generated room code: ", room_code)
	
	# Show room code in LineEdit and wait for confirmation
	var line_edit = get_node("../ButtonContainer/LineEdit")
	line_edit.text = room_code
	line_edit.editable = false  # Make it read-only
	
	# Hide Host button, show a Confirm button
	get_node("../ButtonContainer/HostButton").visible = false
	get_node("../ButtonContainer/VisitButton").visible = false
	
	# Connect to the text submitted signal if not already connected
	if not line_edit.is_connected("text_submitted", _on_host_code_submitted):
		line_edit.text_submitted.connect(_on_host_code_submitted)
	
	print("Please press Enter to start the game with code: ", room_code)

func _on_host_code_submitted(new_text: String):
	print("Starting host game with code: ", room_code)
	
	var error = rtc_peer.create_server()
	if error == OK:
		multiplayer.multiplayer_peer = rtc_peer
		is_server = true
		
		# Hide the connection UI
		get_node("../ButtonContainer").visible = false
		
		# Show character selection buttons
		var rock_button = get_node("../RockButton")
		var stick_button = get_node("../StickButton")
		if rock_button and stick_button:
			rock_button.text = "Rock"
			stick_button.text = "Stick"
			rock_button.visible = true
			stick_button.visible = true
			rock_button.disabled = false
			stick_button.disabled = false
			print("Character selection buttons shown")
		
		$ConnectionHandler.start_listening(room_code)
	else:
		print("Failed to create server. Error: ", error)
		emit_signal("connection_failed")

func join_game(input_code):
	if input_code.length() == 0:
		$"../ErrorLabel".text = "Please enter a room code"
		$"../ErrorLabel".visible = true
		return
		
	room_code = input_code
	print("Joining game with code: ", room_code)
	$"../ErrorLabel".visible = false
	get_node("../ButtonContainer").visible = false  # Hide connection UI
	$ConnectionHandler.join_room(room_code)
	
	# Show character selection buttons for joining player
	var rock_button = get_node("../RockButton")
	var stick_button = get_node("../StickButton")
	if rock_button and stick_button:
		rock_button.text = "Rock"
		stick_button.text = "Stick"
		rock_button.visible = true
		stick_button.visible = true
		rock_button.disabled = false
		stick_button.disabled = false
		print("Character buttons made visible for joining player")

func _on_peer_connected(peer_id: int):
	print("Peer connected: ", peer_id)
	if pending_peers.has(peer_id):
		pending_peers.erase(peer_id)

func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)
	if pending_peers.has(peer_id):
		pending_peers.erase(peer_id)

func _on_connection_failed():
	print("Connection failed")
	$"../ErrorLabel".text = "Failed to connect. Please try again."
	$"../ErrorLabel".visible = true
	get_node("../ButtonContainer").visible = true  # Show connection UI again
	rtc_peer.close()

func _on_player_joined(peer_id: int):
	print("Player joined: ", peer_id)
	emit_signal("player_joined", peer_id)

func _setup_connection(peer_id: int, data: Dictionary):
	if "offer" in data:
		rtc_peer.get_peer(peer_id).connection.set_remote_description(
			"offer", data.offer)
	if "ice_candidates" in data:
		for candidate in data.ice_candidates:
			rtc_peer.get_peer(peer_id).connection.add_ice_candidate(
				candidate.media, candidate.index, candidate.name)

func _on_connection_data(peer_id: int, data: Dictionary):
	if not rtc_peer.has_peer(peer_id):
		var error = rtc_peer.create_client(peer_id)
		if error == OK:
			multiplayer.multiplayer_peer = rtc_peer
			pending_peers[peer_id] = data
			_setup_connection(peer_id, data)
		else:
			print("Failed to create client. Error: ", error)
			emit_signal("connection_failed")

@rpc("any_peer")
func add_player(player_name: String, position: Vector2, character_type: String) -> void:
	print("=== Adding Player ===")
	print("Type: ", character_type)
	print("Position: ", position)
	print("Current multiplayer ID: ", multiplayer.get_unique_id())
	
	var scene_path = "res://Rock.tscn" if character_type == "rock" else "res://Stick.tscn"
	print("Looking for scene at path: ", scene_path)
	
	if not ResourceLoader.exists(scene_path):
		print("ERROR: Scene file does not exist at: ", scene_path)
		return
		
	print("Scene file exists, attempting to load...")
	var player_scene = load(scene_path)
	if not player_scene:
		print("ERROR: Failed to load scene!")
		return
		
	print("Scene loaded successfully")
	var player = player_scene.instantiate()
	
	# Set the name to the peer ID for authority
	var peer_id = multiplayer.get_remote_sender_id()
	if peer_id == 0:  # Local player
		peer_id = multiplayer.get_unique_id()
	player.name = str(peer_id)
	player.position = position
	
	print("Player instance created with name: ", player.name)
	print("Adding to scene tree...")
	
	# Add to the scene
	get_parent().add_child(player)
	print("Player added as child of: ", player.get_parent().name)
	print("Player position set to: ", player.position)

func _on_rock_button_pressed() -> void:
	print("Rock button pressed!")
	print("Current peer ID: ", multiplayer.get_unique_id())
	print("Is server: ", is_server)
	print("Attempting to spawn rock player...")
	
	# Hide buttons first
	var rock_button = get_node("../RockButton")
	var stick_button = get_node("../StickButton")
	if rock_button and stick_button:
		rock_button.visible = false
		stick_button.visible = false
		print("Character buttons hidden after selection")
	
	# Call RPC
	print("Calling add_player RPC...")
	if multiplayer.multiplayer_peer == null:
		print("ERROR: No multiplayer peer!")
		return
		
	add_player.rpc("Player", Vector2(100, 100), "rock")
	print("RPC call completed")

func _on_stick_button_pressed() -> void:
	print("Stick button pressed!")
	rpc.call_deferred("add_player", "Player", Vector2(100, 100), "stick")
	var rock_button = get_node("../RockButton")
	var stick_button = get_node("../StickButton")
	if rock_button and stick_button:
		rock_button.visible = false
		stick_button.visible = false
		print("Character buttons hidden after selection")

func _on_host_button_pressed() -> void:
	host_game()

func _on_visit_button_pressed() -> void:
	var input_code = get_node("../ButtonContainer/LineEdit").text
	join_game(input_code)
