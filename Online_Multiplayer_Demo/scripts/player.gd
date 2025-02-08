extends CharacterBody2D

const SPEED = 300.0

# Use multiplayer_authority to determine who can control this player
func _ready():
	# Set the initial multiplayer authority
	set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if is_multiplayer_authority():
		# Get input direction
		var direction = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)
		
		if direction.length() > 0:
			direction = direction.normalized()
			velocity = direction * SPEED
			# Move using CharacterBody2D's built-in method
			move_and_slide()
			# Sync position with other players
			sync_position.rpc(position)
		else:
			velocity = Vector2.ZERO

# Use "unreliable" for smooth movement updates
@rpc("unreliable", "any_peer", "call_remote")
func sync_position(new_position):
	# Update position for other players
	if not is_multiplayer_authority():
		position = new_position
