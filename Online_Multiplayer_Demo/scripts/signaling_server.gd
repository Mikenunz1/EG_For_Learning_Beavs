extends Node

signal connection_failed
signal player_joined(peer_id: int)

var ws_client := WebSocketPeer.new()
var is_listening := false
var current_room := ""

func _ready():
	# Set up WebSocket signals
	ws_client.connection_established.connect(_on_connection_established)
	ws_client.connection_failed.connect(_on_connection_failed)
	ws_client.data_received.connect(_on_data_received)

func start_listening(room_code: String):
	current_room = room_code
	is_listening = true
	_connect_to_signaling_server()

func join_room(room_code: String):
	current_room = room_code
	is_listening = false
	_connect_to_signaling_server()

func _connect_to_signaling_server():
	var error = ws_client.connect_to_url("wss://your-signaling-server.com")
	if error != OK:
		emit_signal("connection_failed")

func _on_connection_established():
	var msg = {
		"type": "join",
		"room": current_room,
		"is_host": is_listening
	}
	_send_message(msg)

func _on_connection_failed():
	emit_signal("connection_failed")

func _on_data_received():
	var data = ws_client.get_packet().get_string_from_utf8()
	var msg = JSON.parse_string(data)
	
	match msg.type:
		"offer":
			get_parent()._on_connection_data(msg.peer_id, {
				"offer": msg.offer,
				"ice_candidates": msg.candidates
			})
		"answer":
			get_parent()._on_connection_data(msg.peer_id, {
				"answer": msg.answer,
				"ice_candidates": msg.candidates
			})
		"player_joined":
			emit_signal("player_joined", msg.peer_id)

func _send_message(msg: Dictionary):
	var data = JSON.stringify(msg)
	ws_client.send(data.to_utf8_buffer())

func _process(_delta):
	ws_client.poll()
