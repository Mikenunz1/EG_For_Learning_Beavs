extends Node2D

var rock = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingRock.tscn")
var log = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingLogVert.tscn")
var fish = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingFish.tscn")
var goose = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingGoose.tscn")

var spawn_offset = -300
var rng = RandomNumberGenerator.new()
var health = 3

@onready var gameOverText = $MinigameUI/RestartText

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health == 0 && Input.is_action_just_pressed("Action")):
		get_tree().reload_current_scene()

func create_Obstacle():
	var choice = rng.randi_range(1,4)
	
	match choice:
		1:
			spawn_Rock()
			
		2:
			spawn_Log()
			
		3:
			spawn_fish()
			
		4:
			spawn_goose()
	
func noHealth():
	gameOverText.show()
	health = 0	
	get_tree().call_group("Player", "lost")

#The below functions spawn specifc obstacles for the minigame
func spawn_Rock():
	var spawnHeight = rng.randi_range(750, 820)
	var newRock = rock.instantiate()
	get_tree().current_scene.add_child(newRock)
	newRock.global_position = Vector2(spawn_offset, spawnHeight)
	
func spawn_Log():
	var spawnHeight = rng.randi_range(150, 650)
	var newLog = log.instantiate()
	get_tree().current_scene.add_child(newLog)
	newLog.global_position = Vector2(spawn_offset, spawnHeight)
	
func spawn_fish():
	var spawnHeight = rng.randi_range(250, 800)
	var newFish = fish.instantiate()
	get_tree().current_scene.add_child(newFish)
	newFish.global_position = Vector2(spawn_offset, spawnHeight)
	
func spawn_goose():
	var spawnHeight = rng.randi_range(250, 800)
	var newGoose = goose.instantiate()
	get_tree().current_scene.add_child(newGoose)
	newGoose.global_position = Vector2(spawn_offset, spawnHeight)
