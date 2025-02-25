extends Node2D

var rock = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingRock.tscn")
var log = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingLogVert.tscn")

var test = 0
var max = 150
var min = 40

var spawn_offset = -300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test += 1
	
	if (test == 30):
		spawn_Log(400)
	
	if (test == max):
		spawn_Rock(800)
		test = 0
		if (max >= min):
			max = max - 10
	
#The below functions spawn specifc obstacles for the minigame
func spawn_Rock(ypos):
	var newRock = rock.instantiate()
	get_tree().current_scene.add_child(newRock)
	newRock.global_position = Vector2(spawn_offset, ypos)
	
func spawn_Log(ypos):
	var newLog = log.instantiate()
	get_tree().current_scene.add_child(newLog)
	newLog.global_position = Vector2(spawn_offset, ypos)
	
#TODO
#spawn log long
#spawn tree root
#spawn salmon
