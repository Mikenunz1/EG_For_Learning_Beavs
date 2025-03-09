# World.gd
extends Node2D

#Preloads for specific scene
var beaver = preload("res://Game_Files/Scenes/Player/PlayerTreeCutting.tscn")
var tree = preload("res://Game_Files/Scenes/MiniGameComponents/CuttingTree.tscn")
var nutria = preload("res://Game_Files/Scenes/MiniGameComponents/CuttingNutria.tscn")

#UI variables
@onready var winText = $GameUI/WinScreen
@onready var restartText = $GameUI/RestartScreen
@onready var treeNum = $GameUI/TreeCuttingOverlay/TreesNumber

#Ingame Variables
var is_game_over = false
var is_game_won = false
var rng = RandomNumberGenerator.new()
var tree_count = 0

var playX = 300
var playY = 1200

@onready var minigameMusicAudioStreamPlayer = $"AudioStreamPlayer-MinigameMusic"
@onready var treeAudioStream = $"AudioStreamPlayer-TreeSFX"
@onready var minigameSFXAudioStreamPlayer = $"AudioStreamPlayer-MinigameSFX"

@onready var victorySound = load("res://Game_Files/Assets/Audio/Sounds/Minigame SFX/victory-sfx.mp3")
@onready var gameoverSound = load("res://Game_Files/Assets/Audio/Sounds/Minigame SFX/gameover.mp3")
@onready var exit = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx.mp3")
@onready var select = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx3.mp3")
@onready var timber = load("res://Game_Files/Assets/Audio/Sounds/Minigame SFX/Timber.mp3")

func spawnGame():
	#Spawn player
	beaver_spawn(960,540)
	
	#Spawn enemy nutria 
	nutria_spawn(700,900)
	nutria_spawn(700,1100)
	nutria_spawn(100,300)

	# Spawn trees and count them
	tree_count = 0
	tree_spawn(300,300)
	tree_spawn(400,800)
	tree_spawn(1000,200)
	tree_spawn(900,800)
	tree_spawn(1200,500)
	tree_spawn(1400,300)
	tree_spawn(1700,700)
	
	print("Total trees spawned: ", tree_count)

func _ready():
	spawnGame()

#Fucntions for spawning different scene objects --------------------------------
func nutria_spawn(xpos, ypos):
	var newnutria = nutria.instantiate()
	get_tree().current_scene.add_child(newnutria)
	newnutria.global_position = Vector2(xpos,ypos)
	
func beaver_spawn(xpos, ypos):
	var newbeaver = beaver.instantiate()
	get_tree().current_scene.add_child(newbeaver)
	newbeaver.global_position = Vector2(xpos,ypos)

func tree_spawn(xpos, ypos):
	var newtree = tree.instantiate()
	get_tree().current_scene.add_child(newtree)
	newtree.global_position = Vector2(xpos,ypos)
	tree_count += 1  # Increment our tree counter

#Function to update UI and game state when tree is cut -------------------------
func tree_destroyed():
	#tree timber sfx
	treeAudioStream.stream = timber
	treeAudioStream.play()
	tree_count -= 1  # Decrement counter when a tree is destroyed
	updateUI()
	print("Tree destroyed! Trees remaining: ", tree_count)
	if tree_count <= 0:
		print("All trees destroyed - WINNING!")
		win_game()
	
#Updates the progress tracker in UI --------------------------------------------
func updateUI():
	treeNum.text = str(tree_count)
	

#Game Functionality functions --------------------------------------------------		
func game_over():
	if is_game_over or is_game_won:
		return
		
	is_game_over = true
	print("GAME OVER!")
	
	minigameMusicAudioStreamPlayer.stop()
	minigameSFXAudioStreamPlayer.stream = gameoverSound
	minigameSFXAudioStreamPlayer.play()
	
	# Show the game over screen
	restartText.show()

func win_game():
	if is_game_over or is_game_won:
		return
		
	is_game_won = true
	print("YOU WIN!")
	
	minigameMusicAudioStreamPlayer.stop()
	minigameSFXAudioStreamPlayer.stream = victorySound
	minigameSFXAudioStreamPlayer.play()
	
	# Show the win screen
	winText.show()
	
func restartGame():
	get_tree().call_group("trees", "remove_self")	
	get_tree().call_group("enemies", "remove_self")	
	get_tree().call_group("player", "remove_self")	
	is_game_over = false
	spawnGame()
	minigameMusicAudioStreamPlayer.play()
	restartText.hide()

func pause():
	get_tree().call_group("enemies", "stop_movement")
	get_tree().call_group("player", "stopPlayer")
	
func unpause():
	get_tree().call_group("enemies", "start_movement")
	get_tree().call_group("player", "startPlayer")

func gameExit():
	get_tree().call_group("GameManager", "updatePlayerLocation", playX, playY)
	get_tree().call_group("GameManager", "setPlayerScene", "MainMap")
	get_tree().call_group("GameManager", "saveGame")
	get_tree().call_group("GameManager", "loadSceneByFile")
	removeSelf()

func _process(_delta):
	
	# Handle game over restart
	if is_game_over and Input.is_action_just_pressed("Action"):  # Space bar
		restartGame()
	
	# Handle win screen controls
	if is_game_won:
		if Input.is_action_just_pressed("Interact"):
			minigameSFXAudioStreamPlayer.stream = exit
			minigameSFXAudioStreamPlayer.play()
			await get_tree().create_timer(0.1).timeout
			get_tree().call_group("GameManager", "updatePlayerLocation", playX, playY)
			get_tree().call_group("GameManager", "setPlayerScene", "MainMap")
			get_tree().call_group("GameManager", "saveGame")
			get_tree().call_group("GameManager", "loadSceneByFile")
			removeSelf()

		if Input.is_key_pressed(KEY_Q):  # Q key to quit
			print("Q key pressed - quitting game")
			get_tree().quit()
	
#Fuction that all scenes have that remove them from tree
func removeSelf():
	queue_free()
