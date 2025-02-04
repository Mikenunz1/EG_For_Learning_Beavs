extends Node

# Indicates if the current instance is the server
var is_server = false
# WebRTC multiplayer peer instance to handle peer-to-peer communication
var rtc_peer := WebRTCMultiplayerPeer.new()
# Room code for connection
var room_code = ""

func _ready():
	# Set up multiplayer configuration
	multiplayer.multiplayer_peer = rtc_peer

# Host a game session
func host_game():
	# Generate a unique room code for the session
	room_code = str(randi())
	# Set the STUN servers
	rtc_peer.initialize()
	rtc_peer.add_ice_server("stun:stun.l.google.com:19302")
	# Create a WebRTC server
	var error = rtc_peer.create_server()
	if error == OK:
		# Log the room code and set the server flag
		print("Hosting game... Room code: ", room_code)
		is_server = true
	else:
		print("Failed to create server. Error: ", error)

# Join an existing game session using a room code
func join_game(input_code):
	# Set the room code provided by the user
	room_code = input_code
	# Initialize WebRTC peer
	rtc_peer.initialize()
	rtc_peer.add_ice_server("stun:stun.l.google.com:19302")
	# Create a WebRTC client with ID 1 (connecting to host)
	var error = rtc_peer.create_client(1)
	if error == OK:
		print("Joining game with room code: ", room_code)
		$RockButton.visible = true
		$StickButton.visible = true
	else:
		print("Failed to create client. Error: ", error)

# Add a player to the scene
@rpc
func add_player(player_name: String, position: Vector2, character_type: String) -> void:
	# Dynamically determine the scene path based on the character type
	var scene_path = "res://Rock.tscn" if character_type == "rock" else "res://Stick.tscn"
	# Load the player scene
	var player_scene = load(scene_path)
	# Instantiate the player scene
	var player = player_scene.instantiate()
	# Set the player's name and position
	player.name = player_name
	player.position = position
	# Add the player to the scene
	add_child(player)

# Callback for the Host button press
func _on_host_button_pressed() -> void:
	# Start hosting a game session
	host_game()

# Callback for the Visit (Join) button press
func _on_visit_button_pressed() -> void:
	# Retrieve the room code from the input field and join the game
	var input_code = $LineEdit.text
	join_game(input_code)

# Callback for the Rock button press
func _on_rock_button_pressed() -> void:
	# Add the player as a Rock character
	rpc.call_deferred("add_player", "Player", Vector2(100, 100), "rock")
	$RockButton.visible = false
	$StickButton.visible = false

# Callback for the Stick button press
func _on_stick_button_pressed() -> void:
	# Add the player as a Stick character
	rpc.call_deferred("add_player", "Player", Vector2(100, 100), "stick")
	$RockButton.visible = false
	$StickButton.visible = false
