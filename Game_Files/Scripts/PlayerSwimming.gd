extends CharacterBody2D

var SPEED = 600
var gameWon = false

@onready var hitSFXAudioStreamPlayer = $"AudioStreamPlayer2D-HitSFX"
@onready var movementAudioStreamPlayer = $"AudioStreamPlayer2D-MovementSFX"


func _physics_process(_delta):	
	
	var direction = Vector2.ZERO
	var target_velocity = Vector2.ZERO
	
	if (Input.is_action_pressed("Move_Up")):
		direction.y -= 1
		
	if (Input.is_action_pressed("Move_Down")):
		direction.y += 1
		
	target_velocity.x = 0
	target_velocity.y  = direction.y * SPEED
	
	velocity = target_velocity
	
	#player movement sound control
	if movementAudioStreamPlayer:
		if target_velocity:
			if!movementAudioStreamPlayer.playing:
				movementAudioStreamPlayer.play()
		else: 
			movementAudioStreamPlayer.stop()

	#Built in function within Godot that deals with player movement
	move_and_slide()

func setPosition(x,y):
	global_position = Vector2(x,y)
	
#Collision scripting that determines if player collides with something
func _on_scripting_area_area_entered(area):
	if (area.is_in_group("Obstacle")):
		hitSFXAudioStreamPlayer.play()
		get_tree().call_group("MinigameUI", "decreaseHealth")

func stopPlayer():
	SPEED = 0
	
func startPlayer():
	SPEED = 600
	
