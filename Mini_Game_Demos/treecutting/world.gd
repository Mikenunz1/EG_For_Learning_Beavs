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
var game_over_screen
var win_screen
var is_game_over = false
var is_game_won = false
var rng = RandomNumberGenerator.new()
var spawn_offset = -300

# Track the number of trees directly
var tree_count = 0

func _ready():
	
	beaver_spawn(960,540)
	
	nutria_spawn(700,900)
	nutria_spawn(700,1100)
	nutria_spawn(100,1000)

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

func tree_spawn(xpos, ypos):
	var newtree = tree.instantiate()
	get_tree().current_scene.add_child(newtree)
	newtree.global_position = Vector2(xpos,ypos)
	tree_count += 1  # Increment our tree counter

func tree_destroyed():
	tree_count -= 1  # Decrement counter when a tree is destroyed
	updateUI()
	print("Tree destroyed! Trees remaining: ", tree_count)
	if tree_count <= 0:
		print("All trees destroyed - WINNING!")
		win_game()

func nutria_spawn(xpos, ypos):
	var newnutria = nutria.instantiate()
	get_tree().current_scene.add_child(newnutria)
	newnutria.global_position = Vector2(xpos,ypos)
	
func beaver_spawn(xpos, ypos):
	var newbeaver = beaver.instantiate()
	get_tree().current_scene.add_child(newbeaver)
	newbeaver.global_position = Vector2(xpos,ypos)
	
func updateUI():
	treeNum.text = str(tree_count)
	
func check_win_condition():
	# Method 1: Check using tree_count
	if tree_count <= 0:
		print("Win check: No trees left by counter!")
		win_game()
		return
	
	# Method 2: Check using group count
	var trees_left = get_tree().get_nodes_in_group("trees").size()
	print("Win check: Trees left by group count: ", trees_left)
	
	if trees_left == 0:
		print("Win check: No trees left by group count!")
		win_game()

func game_over():
	if is_game_over or is_game_won:
		return
		
	is_game_over = true
	print("GAME OVER!")
	
	# Show the game over screen
	restartText.show()

func win_game():
	if is_game_over or is_game_won:
		return
		
	is_game_won = true
	print("YOU WIN!")
	
	# Update the score on the win screen
	var score_label = win_screen.get_node("ScoreLabel")
	
	# Show the win screen
	winText.show()

func _process(_delta):
	# Check for ESC key to quit the game
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		print("ESC key pressed - quitting game")
		get_tree().quit()
	
	# Handle game over restart
	if is_game_over and Input.is_action_just_pressed("Action"):  # Space bar
		get_tree().reload_current_scene()  # Restart the game
	
	# Handle win screen controls
	if is_game_won:
		if Input.is_action_just_pressed("Action"):  # R key to restart
			print("R key pressed - restarting game")
			get_tree().reload_current_scene()
		
		if Input.is_key_pressed(KEY_Q):  # Q key to quit
			print("Q key pressed - quitting game")
			get_tree().quit()
	
	# Alternative win condition check every few frames
	if not is_game_won and not is_game_over and Engine.get_physics_frames() % 30 == 0:  # Check every 30 frames
		check_win_condition()
