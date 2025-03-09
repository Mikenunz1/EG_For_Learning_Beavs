extends Node2D

var rock = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingRock.tscn")
var vertlog = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingLogVert.tscn")
var fish = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingFish.tscn")
var goose = preload("res://Game_Files/Scenes/MiniGameComponents/SwimmingGoose.tscn")

var spawn_offset = -300
var rng = RandomNumberGenerator.new()
var health = 3
var win = false
var playX = 6673
var playY = 3200

@onready var gameOverText = $MinigameUI/RestartText
@onready var gameWinText = $MinigameUI/WinText
@onready var timer = $GameTimer
@onready var spawnTimer = $SpawnTimer

@onready var minigameMusicAudioStreamPlayer = $"AudioStreamPlayer-MinigameMusic"
@onready var minigameSFXAudioStreamPlayer = $"AudioStreamPlayer-MinigameSFX"

@onready var victorySound = load("res://Game_Files/Assets/Audio/Sounds/Minigame SFX/victory-sfx.mp3")
@onready var gameoverSound = load("res://Game_Files/Assets/Audio/Sounds/Minigame SFX/gameover.mp3")
@onready var exit = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx.mp3")
@onready var select = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx3.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (health == 0):
		timer.paused = true
	
	if (health == 0 && Input.is_action_just_pressed("Action")):
		minigameSFXAudioStreamPlayer.stream = exit
		minigameSFXAudioStreamPlayer.play()
		await get_tree().create_timer(0.1).timeout
		restart()
		
	get_tree().call_group("MinigameUI", "updateProgress", timer.time_left)
	
	if (win && Input.is_action_just_pressed("Action")):
		minigameSFXAudioStreamPlayer.stream = select
		minigameSFXAudioStreamPlayer.play()
		await get_tree().create_timer(0.1).timeout
		get_tree().call_group("GameManager", "updatePlayerLocation", playX, playY)
		get_tree().call_group("GameManager", "setPlayerScene", "MainMap")
		get_tree().call_group("GameManager", "saveGame")
		get_tree().call_group("GameManager", "loadSceneByFile")
		removeSelf()
		
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
	minigameSFXAudioStreamPlayer.stream = gameoverSound
	minigameSFXAudioStreamPlayer.play()
	gameOverText.show()
	health = 0	
	get_tree().call_group("Obstacle", "stop_movement")
	get_tree().call_group("Player", "stopPlayer")

#The below functions spawn specifc obstacles for the minigame
func spawn_Rock():
	var spawnHeight = rng.randi_range(800, 820)
	var newRock = rock.instantiate()
	get_tree().current_scene.add_child(newRock)
	newRock.global_position = Vector2(spawn_offset, spawnHeight)
	
func spawn_Log():
	var spawnHeight = rng.randi_range(50, 650)
	var newLog = vertlog.instantiate()
	get_tree().current_scene.add_child(newLog)
	newLog.global_position = Vector2(spawn_offset, spawnHeight)
	
func spawn_fish():
	var spawnHeight = rng.randi_range(150, 800)
	var newFish = fish.instantiate()
	get_tree().current_scene.add_child(newFish)
	newFish.global_position = Vector2(spawn_offset, spawnHeight)
	
func spawn_goose():
	var spawnHeight = rng.randi_range(250, 600)
	var newGoose = goose.instantiate()
	get_tree().current_scene.add_child(newGoose)
	newGoose.global_position = Vector2(spawn_offset, spawnHeight)
	
func game_win():
	minigameMusicAudioStreamPlayer.stop()
	minigameSFXAudioStreamPlayer.stream = victorySound
	minigameSFXAudioStreamPlayer.play()
	gameWinText.show()
	get_tree().call_group("Player", "stopPlayer")
	get_tree().call_group("Obstacle", "stop_movement")
	spawnTimer.stop()
	win = true

func restart():
	get_tree().call_group("Obstacle", "remove")
	get_tree().call_group("Player", "startPlayer")
	get_tree().call_group("MinigameUI", "restartProgress")
	health = 3
	timer.start()
	timer.paused = false
	spawnTimer.start()
	gameOverText.hide()
	
func gameExit():
	get_tree().call_group("GameManager", "updatePlayerLocation", playX, playY)
	get_tree().call_group("GameManager", "setPlayerScene", "MainMap")
	get_tree().call_group("GameManager", "saveGame")
	get_tree().call_group("GameManager", "loadSceneByFile")
	removeSelf()
	
func pause():
	get_tree().call_group("Obstacle", "stop_movement")
	get_tree().call_group("Player", "stopPlayer")
	timer.paused = true
	spawnTimer.paused = true
	
func unpause():
	get_tree().call_group("Obstacle", "start_movement")
	get_tree().call_group("Player", "startPlayer")
	timer.paused = false
	spawnTimer.paused = false

#Fuction that all scenes have that remove them from tree
func removeSelf():
	queue_free()
