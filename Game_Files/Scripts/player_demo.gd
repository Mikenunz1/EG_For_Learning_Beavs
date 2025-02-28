extends CharacterBody2D

class_name Player

const SPEED = 350.0

#variables for player AudioStreamPlayers
@onready var playerWalkingAudioStream = get_node_or_null("AudioStreamPlayer2DWalking")

#variables for movement audio streams
@onready var playerWalkingGrassSound = load("res://Game_Files/Assets/Audio/Sounds/Movement SFX/Leaves walk fast.mp3")
@onready var playerWalkingMudSound = load("res://Game_Files/Assets/Audio/Sounds/Movement SFX/Mud walk 2.mp3")
@onready var playerWalkingGravelSound = load("res://Game_Files/Assets/Audio/Sounds/Movement SFX/Gravel walk fast.mp3")
@onready var playerWalkingWaterSound = load("res://Game_Files/Assets/Audio/Sounds/Movement SFX/Water slaps 2.mp3")
@onready var playerWalkingSandSound = load("res://Game_Files/Assets/Audio/Sounds/Movement SFX/Dirt walk fast.mp3")
@onready var playerWalkingWoodSound = load("res://Game_Files/Assets/Audio/Sounds/Movement SFX/Wood steps fast.mp3")

#work in progress
#needs to be able to return the audiostream for the tile the player is on
func getMovementSound():
	return playerWalkingGrassSound

func _physics_process(_delta):	
	
	#Input_directon is a vector variable determined by user input. 
	var input_direction = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
	velocity = input_direction * SPEED
	
	#player movement sound control
	if playerWalkingAudioStream:
		if input_direction:
			if!playerWalkingAudioStream.playing:
				playerWalkingAudioStream.stream = (getMovementSound())
				playerWalkingAudioStream.play()
		else: 
			playerWalkingAudioStream.stop()

	#Built in function within Godot that deals with player movement
	move_and_slide()

func setPosition(x,y):
	print(x)
	print(y)
	global_position = Vector2(x,y)

func sendToManager():
	get_tree().call_group("GameManager", "updatePlayerLocation", global_position.x, global_position.y)
