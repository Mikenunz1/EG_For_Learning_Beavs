extends Node
class_name ConnectionHandler

signal connection_failed
signal player_joined(peer_id: int)

var ws_client := WebSocketPeer.new()
var is_listening := false
var current_room := ""

func _ready():
	# Set up WebSocket connection with the Render.com server
	var err = ws_client.connect_to_url("wss://signaling-server-diku.onrender.com")
	if err != OK:
		print("WebSocket connection failed with error: ", err)
		emit_signal("connection_failed")

func start_listening(room_code: String):
	current_room = room_code
	is_listening = true
	print("Starting to listen on room: ", room_code)
	_send_message({
		"type": "join",
		"room": current_room,
		"is_host": true
	})

func join_room(room_code: String):
	current_room = room_code
	is_listening = false
	print("Joining room: ", room_code)
	_send_message({
		"type": "join",
		"room": current_room,
		"is_host": false
	})

func _send_message(msg: Dictionary):
	var data = JSON.stringify(msg)
	print("Sending message: ", data)
	ws_client.send_text(data)

func _process(_delta):
	ws_client.poll()
	
	var state = ws_client.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while ws_client.get_available_packet_count():
			var packet = ws_client.get_packet()
			var text = packet.get_string_from_utf8()
			print("Received packet: ", text)
			var json = JSON.parse_string(text)
			if json:
				_handle_message(json)
	elif state == WebSocketPeer.STATE_CLOSED:
		print("WebSocket closed with code: ", ws_client.get_close_code())
		emit_signal("connection_failed")

func _handle_message(msg: Dictionary):
	print("Handling message: ", msg)
	
	if not "type" in msg:
		print("Message has no type field")
		return
		
	match msg.type:
		"offer":
			if "id" in msg:
				get_parent()._on_connection_data(msg.id, {
					"offer": msg.offer,
					"ice_candidates": msg.get("candidates", [])
				})
		"answer":
			if "id" in msg:
				get_parent()._on_connection_data(msg.id, {
					"answer": msg.answer,
					"ice_candidates": msg.get("candidates", [])
				})
		"player_joined":
			if "id" in msg:
				print("Player joined with id: ", msg.id)
				emit_signal("player_joined", msg.id)
		"peer-id":
			if "id" in msg:
				print("Received peer ID: ", msg.id)
