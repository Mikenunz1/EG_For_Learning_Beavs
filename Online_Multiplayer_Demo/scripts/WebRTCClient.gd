extends Node
class_name WebRTCClient

signal connected_to_server
signal connection_failed
signal peer_connected(peer_id)
signal peer_disconnected(peer_id)

const SIGNALING_URL = "wss://signaling-server-diku.onrender.com"

var signaling: WebRTCSignaling
var rtc_mp: WebRTCMultiplayerPeer
var peer_connections: Dictionary = {}
var is_server: bool = false
var room_code: String = ""

func _init() -> void:
	signaling = WebRTCSignaling.new()
	rtc_mp = WebRTCMultiplayerPeer.new()
	
	# Connect signaling signals
	signaling.peer_connected.connect(_on_signaling_peer_connected)
	signaling.peer_disconnected.connect(_on_signaling_peer_disconnected)
	signaling.offer_received.connect(_on_signaling_offer_received)
	signaling.answer_received.connect(_on_signaling_answer_received)
	signaling.candidate_received.connect(_on_signaling_candidate_received)
	
func _ready() -> void:
	add_child(signaling)
	print("Connecting to signaling server...")
	var err = signaling.connect_to_server(SIGNALING_URL)
	if err != OK:
		print("Failed to connect to signaling server: ", err)
		emit_signal("connection_failed")
	else:
		emit_signal("connected_to_server")

func _process(_delta: float) -> void:
	if rtc_mp:
		rtc_mp.poll()
	
	for connection in peer_connections.values():
		if connection.connection:
			connection.connection.poll()

func create_server(code: String) -> void:
	print("Creating server for room:", code)
	room_code = code
	is_server = true
	
	# Reset multiplayer peer
	multiplayer.multiplayer_peer = null
	rtc_mp = WebRTCMultiplayerPeer.new()
	
	var err = rtc_mp.create_server()
	if err == OK:
		print("Server created successfully")
		multiplayer.multiplayer_peer = rtc_mp
		signaling.create_room(room_code)
		emit_signal("connected_to_server")
	else:
		print("Failed to create server with error:", err)
		emit_signal("connection_failed")

func join_server(code: String) -> void:
	print("Joining server for room:", code)
	room_code = code
	is_server = false
	
	# Reset multiplayer peer
	multiplayer.multiplayer_peer = null
	rtc_mp = WebRTCMultiplayerPeer.new()
	
	# Initialize WebRTC peer connection first
	var peer_connection = WebRTCPeerConnection.new()
	var init_dict = {
		"iceServers": [
			{ "urls": ["stun:stun.l.google.com:19302"] }
		]
	}
	
	var init_err = peer_connection.initialize(init_dict)
	if init_err != OK:
		print("Failed to initialize peer connection:", init_err)
		emit_signal("connection_failed")
		return
		
	print("Creating client...")
	var err = rtc_mp.create_client(2)  # Client uses ID 2
	if err == OK:
		print("Client created successfully")
		multiplayer.multiplayer_peer = rtc_mp
		
		# Add the peer connection
		rtc_mp.add_peer(peer_connection, 1)  # 1 is the server's ID
		peer_connections[1] = {
			"connection": peer_connection,
			"connected": false
		}
		
		# Connect to room via signaling
		signaling.join_room(room_code)
		emit_signal("connected_to_server")
	else:
		print("Failed to create client with error:", err)
		emit_signal("connection_failed")

func _on_signaling_peer_connected(id: int) -> void:
	print("Peer connected to signaling server:", id)
	if not peer_connections.has(id):
		_create_peer_connection(id)
	emit_signal("peer_connected", id)

func _on_signaling_peer_disconnected(id: int) -> void:
	print("Peer disconnected from signaling server:", id)
	if peer_connections.has(id):
		_cleanup_peer_connection(id)
		emit_signal("peer_disconnected", id)

func _on_signaling_offer_received(peer_id: int, offer: String) -> void:
	print("Got offer from peer:", peer_id)
	if not peer_connections.has(peer_id):
		_create_peer_connection(peer_id)
	
	var conn = peer_connections[peer_id]
	if conn and conn.connection:
		var err = conn.connection.set_remote_description("offer", offer)
		if err != OK:
			print("Error setting remote description:", err)
			emit_signal("connection_failed")
			return
			
		# Create answer
		err = conn.connection.create_answer()
		if err != OK:
			print("Error creating answer:", err)
			emit_signal("connection_failed")

func _on_signaling_answer_received(peer_id: int, answer: String) -> void:
	print("Got answer from peer:", peer_id)
	if peer_connections.has(peer_id):
		var conn = peer_connections[peer_id]
		if conn and conn.connection:
			var err = conn.connection.set_remote_description("answer", answer)
			if err != OK:
				print("Error setting remote description:", err)
				emit_signal("connection_failed")

func _on_signaling_candidate_received(peer_id: int, mid: String, index: int, sdp: String) -> void:
	print("Got candidate from peer:", peer_id)
	if peer_connections.has(peer_id):
		var conn = peer_connections[peer_id]
		if conn and conn.connection:
			var err = conn.connection.add_ice_candidate(mid, index, sdp)
			if err != OK:
				print("Error adding ICE candidate:", err)
				emit_signal("connection_failed")

func _create_peer_connection(peer_id: int) -> void:
	print("Creating peer connection for:", peer_id)
	
	# Initialize WebRTC connection
	var peer_connection = WebRTCPeerConnection.new()
	var init_dict = {
		"iceServers": [
			{ "urls": ["stun:stun.l.google.com:19302"] }
		]
	}
	
	var err = peer_connection.initialize(init_dict)
	if err != OK:
		print("Failed to initialize peer connection:", err)
		emit_signal("connection_failed")
		return
		
	# Connect WebRTC signals
	peer_connection.session_description_created.connect(
		_on_connection_description_created.bind(peer_id))
	peer_connection.ice_candidate_created.connect(
		_on_connection_ice_candidate_created.bind(peer_id))
		
	# Add to multiplayer peer
	rtc_mp.add_peer(peer_connection, peer_id)
	
	# Store in our connections dictionary
	peer_connections[peer_id] = {
		"connection": peer_connection,
		"connected": false
	}
	
	# Create offer if we're the server
	if is_server:
		err = peer_connection.create_offer()
		if err != OK:
			print("Error creating offer:", err)
			emit_signal("connection_failed")

func _cleanup_peer_connection(peer_id: int) -> void:
	if peer_connections.has(peer_id):
		var conn = peer_connections[peer_id].connection
		if conn:
			conn.close()
		peer_connections.erase(peer_id)

func _on_connection_description_created(type: String, sdp: String, peer_id: int) -> void:
	print("Description created:", type, "for peer:", peer_id)
	if peer_connections.has(peer_id):
		var conn = peer_connections[peer_id].connection
		if conn:
			var err = conn.set_local_description(type, sdp)
			if err != OK:
				print("Error setting local description:", err)
				emit_signal("connection_failed")
				return
				
			if type == "offer":
				signaling.send_offer(peer_id, sdp)
			else:
				signaling.send_answer(peer_id, sdp)

func _on_connection_ice_candidate_created(mid: String, index: int, sdp: String, peer_id: int) -> void:
	signaling.send_candidate(peer_id, mid, index, sdp)
