extends Node2D

var rock = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingRock.tscn")
var log = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingLogVert.tscn")

var test = 0
var max = 150
var min = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test += 1
	
	if (test == 30):
		spawn_Log(-300, 400)
	
	if (test == max):
		spawn_Rock(-300, 800)
		test = 0
		if (max >= min):
			max = max - 10
	
#The below functions spawn specifc obstacles for the minigame
func spawn_Rock(xpos, ypos):
	var newRock = rock.instantiate()
	get_tree().current_scene.add_child(newRock)
	newRock.global_position = Vector2(xpos, ypos)
	
func spawn_Log(xpos, ypos):
	var newLog = log.instantiate()
	get_tree().current_scene.add_child(newLog)
	newLog.global_position = Vector2(xpos, ypos)
