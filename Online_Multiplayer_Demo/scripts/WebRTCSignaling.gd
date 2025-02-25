extends Node
class_name WebRTCSignaling

signal peer_connected(peer_id)
signal peer_disconnected(peer_id)
signal offer_received(peer_id, offer)
signal answer_received(peer_id, answer)
signal candidate_received(peer_id, mid, index, sdp)

var ws_client := WebSocketPeer.new()
var is_listening := false
var current_room := ""
var is_server := false
var client_peer_id: int = 0  # Renamed to avoid shadowing

func _ready():
	print("Signaling ready")

func _process(_delta):
	ws_client.poll()
	var state = ws_client.get_ready_state()
	
	match state:
		WebSocketPeer.STATE_OPEN:
			while ws_client.get_available_packet_count():
				var packet = ws_client.get_packet()
				var string = packet.get_string_from_utf8()
				var json = JSON.parse_string(string)
				if json:
					_handle_message(json)
		WebSocketPeer.STATE_CLOSED:
			print("WebSocket closed with code: ", ws_client.get_close_code())
			is_listening = false
			
func connect_to_server(url: String) -> Error:
	print("Connecting to signaling server: ", url)
	return ws_client.connect_to_url(url)

func create_room(room_code: String) -> void:
	print("Creating room: ", room_code)
	current_room = room_code
	is_server = true
	_send_join_room()
	
func join_room(room_code: String) -> void:
	print("Joining room: ", room_code)
	current_room = room_code
	is_server = false
	_send_join_room()
	
func _send_join_room() -> void:
	_send_message({
		"type": "join",
		"room": current_room,
		"is_host": is_server
	})

func send_offer(receiver_id: int, offer: String) -> void:
	_send_message({
		"type": "offer",
		"room": current_room,
		"offer": offer,
		"from": client_peer_id,
		"to": receiver_id
	})

func send_answer(receiver_id: int, answer: String) -> void:
	_send_message({
		"type": "answer",
		"room": current_room,
		"answer": answer,
		"from": client_peer_id,
		"to": receiver_id
	})

func send_candidate(receiver_id: int, mid: String, index: int, sdp: String) -> void:
	_send_message({
		"type": "candidate",
		"room": current_room,
		"candidate": {
			"mid": mid,
			"index": index,
			"sdp": sdp
		},
		"from": client_peer_id,
		"to": receiver_id
	})

func _send_message(message: Dictionary) -> void:
	if ws_client.get_ready_state() != WebSocketPeer.STATE_OPEN:
		print("WebSocket not ready, state: ", ws_client.get_ready_state())
		return
		
	var json_string = JSON.stringify(message)
	print("Sending message: ", json_string)
	ws_client.send_text(json_string)

func _handle_message(message: Dictionary) -> void:
	print("Handling message type: ", message.type)
	
	match message.type:
		"peer-id":
			client_peer_id = message.peerId
			emit_signal("peer_connected", client_peer_id)
			
		"player-joined":
			emit_signal("peer_connected", message.peerId)
			
		"player-disconnected":
			emit_signal("peer_disconnected", message.peerId)
			
		"offer":
			if message.has("offer"):
				emit_signal("offer_received", message.from, message.offer)
			
		"answer":
			if message.has("answer"):
				emit_signal("answer_received", message.from, message.answer)
			
		"candidate":
			if message.has("candidate"):
				var candidate = message.candidate
				emit_signal("candidate_received", message.from, 
						   candidate.mid, candidate.index, candidate.sdp)
