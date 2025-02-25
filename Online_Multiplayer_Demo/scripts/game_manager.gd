extends Node

var webrtc_client: WebRTCClient
var spawned_players = {}

func _ready():
	setup_webrtc()
	setup_ui_buttons()

func setup_webrtc():
	webrtc_client = WebRTCClient.new()
	add_child(webrtc_client)
	
	# Connect signals
	webrtc_client.connected_to_server.connect(_on_connected_to_server)
	webrtc_client.connection_failed.connect(_on_connection_failed)
	webrtc_client.peer_connected.connect(_on_peer_connected)
	webrtc_client.peer_disconnected.connect(_on_peer_disconnected)

func setup_ui_buttons():
	# Setup Host and Visit buttons
	var host_btn = get_node("../ButtonContainer/HostButton")
	var visit_btn = get_node("../ButtonContainer/VisitButton")
	
	if host_btn:
		host_btn.pressed.connect(_on_host_button_pressed)
	if visit_btn:
		visit_btn.pressed.connect(_on_visit_button_pressed)
	
	# Setup Rock and Stick buttons
	var rock_btn = get_node_or_null("../RockButton")
	var stick_btn = get_node_or_null("../StickButton")
	
	if rock_btn:
		rock_btn.pressed.connect(_on_rock_button_pressed)
	if stick_btn:
		stick_btn.pressed.connect(_on_stick_button_pressed)
	
	if rock_btn and stick_btn:
		rock_btn.text = "Rock"
		stick_btn.text = "Stick"
		rock_btn.visible = false
		stick_btn.visible = false

func host_game():
	var room_code = str(randi() % 10000).pad_zeros(4)
	get_node("../ButtonContainer/LineEdit").text = room_code
	webrtc_client.create_server(room_code)
	
	get_node("../ButtonContainer/HostButton").visible = false
	get_node("../ButtonContainer/VisitButton").visible = false
	show_character_buttons()

func join_game(room_code: String):
	if room_code.length() == 0:
		show_error("Please enter a room code")
		return
		
	webrtc_client.join_server(room_code)
	get_node("../ButtonContainer").visible = false

func _on_connected_to_server():
	print("Connected to signaling server")
	show_character_buttons()

func _on_connection_failed():
	print("Connection failed")
	show_error("Failed to connect. Please try again.")
	get_node("../ButtonContainer").visible = true

func _on_peer_connected(peer_id: int):
	print("Peer connected: ", peer_id)
	# Synchronize our character if we have one
	if spawned_players.has(multiplayer.get_unique_id()):
		var data = spawned_players[multiplayer.get_unique_id()]
		rpc_id(peer_id, "add_player", multiplayer.get_unique_id(), data.position, data.type)

func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)
	if spawned_players.has(peer_id):
		spawned_players.erase(peer_id)
		var player = get_node_or_null("Node2D/Player_" + str(peer_id))
		if player:
			player.queue_free()

func show_error(message: String):
	var error_label = get_node("../ErrorLabel")
	if error_label:
		error_label.text = message
		error_label.visible = true

func hide_error():
	var error_label = get_node("../ErrorLabel")
	if error_label:
		error_label.visible = false

func show_character_buttons():
	var rock_btn = get_node("../RockButton")
	var stick_btn = get_node("../StickButton")
	if rock_btn and stick_btn:
		rock_btn.visible = true
		stick_btn.visible = true
		rock_btn.disabled = false
		stick_btn.disabled = false

func hide_character_buttons():
	var rock_btn = get_node("../RockButton")
	var stick_btn = get_node("../StickButton")
	if rock_btn and stick_btn:
		rock_btn.visible = false
		stick_btn.visible = false

@rpc("any_peer")
func add_player(player_id: int, position: Vector2, character_type: String) -> void:
	print("Adding player:", player_id)
	
	var node_name = "Player_" + str(player_id)
	if get_node_or_null("../" + node_name):
		print("Player already exists")
		return
	
	var scene_path = "res://Rock.tscn"
	var player_scene = load(scene_path)
	if not player_scene:
		print("Failed to load player scene")
		return
		
	var player = player_scene.instantiate()
	player.name = node_name
	player.position = position
	
	# Set multiplayer authority before adding to scene
	print("Setting multiplayer authority to:", player_id)
	player.set_multiplayer_authority(player_id)
	
	get_node("..").add_child(player)
	
	# Store player data
	spawned_players[player_id] = {
		"position": position,
		"type": character_type
	}
	print("Player added successfully")
	print("Player node name:", player.name)
	print("Player multiplayer authority:", player.get_multiplayer_authority())
	
func _on_rock_button_pressed():
	print("Rock button pressed")
	hide_character_buttons()
	var pos = Vector2(100, 100)
	
	# Spawn locally and inform others
	add_player(multiplayer.get_unique_id(), pos, "rock")
	rpc("add_player", multiplayer.get_unique_id(), pos, "rock")

func _on_stick_button_pressed():
	print("Stick button pressed")
	hide_character_buttons()
	var pos = Vector2(100, 100)
	
	# Spawn locally and inform others
	add_player(multiplayer.get_unique_id(), pos, "stick")
	rpc("add_player", multiplayer.get_unique_id(), pos, "stick")

func _on_host_button_pressed():
	host_game()

func _on_visit_button_pressed():
	var input_code = get_node("../ButtonContainer/LineEdit").text
	join_game(
		
		input_code)
