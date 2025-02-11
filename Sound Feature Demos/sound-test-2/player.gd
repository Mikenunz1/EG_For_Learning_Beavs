extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var playerWalkingAudioStream = $AudioStreamPlayer2DWalking
@onready var playerJumpingAudioStream = $AudioStreamPlayer2DJumping

func _physics_process(delta: float) -> void:
	var playerWalkingConcreteSound = load("res://walking.mp3")
	var playerWalkingMudSound = load("res://mudwalk.mp3")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Move_Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		playerJumpingAudioStream.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			if!playerWalkingAudioStream.playing:
				playerWalkingAudioStream.stream = (playerWalkingConcreteSound)
				playerWalkingAudioStream.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		playerWalkingAudioStream.stop()

	move_and_slide()
