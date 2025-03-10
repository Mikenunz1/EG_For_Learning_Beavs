extends Area2D

@export var SPEED = 600

var pauseSpeed = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += SPEED * delta * pauseSpeed;
	
func stop_movement():
	pauseSpeed = 0
	
func start_movement():
	pauseSpeed = 1
	
func remove():
	queue_free()
