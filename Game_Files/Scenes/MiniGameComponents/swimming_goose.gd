extends Area2D

@export var SPEED = 600

@onready var honkAudioStream = $"AudioStreamPlayer2D-HonkSFX"
var rng = RandomNumberGenerator.new()
var max_honks = 2
var pauseSpeed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += SPEED * delta * pauseSpeed;
	
	#randomly iniate honking noise
	if max_honks > 0:
		var random_num = rng.randf_range(0, 100.0)
		if ((honkAudioStream != null) && (!honkAudioStream.is_playing()) && (random_num > 99.0)):
			honkAudioStream.play()
			max_honks -= 1

func stop_movement():
	pauseSpeed = 0
	
func start_movement():
	pauseSpeed = 1
	
func remove():
	queue_free()
