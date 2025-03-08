# World.gd
extends Node2D

#NEW VARIABLES
@onready var background = $Background


var score = 0
var score_label
var game_over_screen
var win_screen
var is_game_over = false
var is_game_won = false
var rng = RandomNumberGenerator.new()
var spawn_offset = -300
var beaver = preload("res://Game_Files/Scenes/Player/PlayerTreeCutting.tscn")
var tree = preload("res://Game_Files/Scenes/MiniGameComponents/CuttingTree.tscn")
var nutria = preload("res://Game_Files/Scenes/MiniGameComponents/CuttingNutria.tscn")

# Track the number of trees directly
var tree_count = 0

func _ready():
	# Set window size to 2000x2000
	DisplayServer.window_set_size(Vector2i(2000, 2000))
	
	# Center the background
	background.position = Vector2(1000, 1000)  # Center of the 2000x2000 window
	# Get the original texture size
	#var texture_size = texture.get_size()
	#print("Original texture size: ", texture_size)
	
	# Calculate scale to make it exactly 2000x2000
	#var scale_x = 2000.0 / texture_size.x
	#var scale_y = 2000.0 / texture_size.y
	#background.scale = Vector2(scale_x, scale_y)
	
	#print("Applied scale: ", background.scale)
	
	# Create score label with custom font
	setup_score_label()
	
	# Create game over screen but don't show it yet
	create_game_over_screen()
	
	# Create win screen but don't show it yet
	create_win_screen()
	
	beaver_spwan(300,300)
	
	nutria_spwan(700,900)
	nutria_spwan(700,1100)
	nutria_spwan(100,1000)


	# Spawn trees and count them
	tree_count = 0
	tree_spwan(600,300)
	tree_spwan(300,800)
	tree_spwan(1500,300)
	tree_spwan(900,1100)
	tree_spwan(1200,500)
	tree_spwan(1600,900)
	tree_spwan(1800,1300)
	
	print("Total trees spawned: ", tree_count)

func tree_spwan(xpos, ypos):
	var newtree = tree.instantiate()
	get_tree().current_scene.add_child(newtree)
	newtree.global_position = Vector2(xpos,ypos)
	tree_count += 1  # Increment our tree counter

func tree_destroyed():
	tree_count -= 1  # Decrement counter when a tree is destroyed
	print("Tree destroyed! Trees remaining: ", tree_count)
	if tree_count <= 0:
		print("All trees destroyed - WINNING!")
		win_game()

func nutria_spwan(xpos, ypos):
	var newnutria = nutria.instantiate()
	get_tree().current_scene.add_child(newnutria)
	newnutria.global_position = Vector2(xpos,ypos)
	
func beaver_spwan(xpos, ypos):
	var newbeaver = beaver.instantiate()
	get_tree().current_scene.add_child(newbeaver)
	newbeaver.global_position = Vector2(xpos,ypos)
	
func setup_score_label():
	score_label = Label.new()
	score_label.text = "Score: 0"
	score_label.position = Vector2(1300, 10)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	# Load the custom font
	var font_path = "res://fonts/7pxMONOkeychainn.ttf"
	if ResourceLoader.exists(font_path):
		var font = load(font_path)
		score_label.add_theme_font_override("font", font)
		print("Successfully loaded custom pixel font!")
	else:
		print("WARNING: Could not find custom font at:", font_path)
	
	# Make the font larger (adjust this value as needed since it's a pixel font)
	score_label.add_theme_font_size_override("font_size", 128)
	
	# Add outline to make the text stand out more
	score_label.add_theme_constant_override("outline_size", 2)
	score_label.add_theme_color_override("font_outline_color", Color.BLACK)
	
	add_child(score_label)
	
func add_score(points):
	if is_game_over or is_game_won:
		return
		
	score += points
	score_label.text = "Score: " + str(score)
	
	# Alternative win check
	check_win_condition()

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

func create_game_over_screen():
	# Create a canvas layer to show UI on top of everything
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# Create the game over control
	game_over_screen = Control.new()
	game_over_screen.visible = false
	canvas_layer.add_child(game_over_screen)
	
	# Add a semi-transparent background
	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.7)  # Semi-transparent black
	background.size = Vector2(2000, 2000)
	game_over_screen.add_child(background)
	
	# Add "GAME OVER" text
	var game_over_label = Label.new()
	game_over_label.text = "GAME OVER"
	game_over_label.add_theme_font_size_override("font_size", 72)
	game_over_label.add_theme_color_override("font_color", Color.WHITE)
	game_over_label.position = Vector2(800, 400)
	game_over_screen.add_child(game_over_label)
	
	# Add score text (will be updated when game over happens)
	var final_score_label = Label.new()
	final_score_label.name = "ScoreLabel"  # Give it a name so we can find it later
	final_score_label.add_theme_font_size_override("font_size", 36)
	final_score_label.add_theme_color_override("font_color", Color.WHITE)
	final_score_label.position = Vector2(800, 500)
	game_over_screen.add_child(final_score_label)
	
	# Add restart instructions
	var restart_label = Label.new()
	restart_label.text = "Press SPACE to restart"
	restart_label.add_theme_font_size_override("font_size", 36)
	restart_label.add_theme_color_override("font_color", Color.WHITE)
	restart_label.position = Vector2(800, 600)
	game_over_screen.add_child(restart_label)

func create_win_screen():
	# Create a canvas layer to show UI on top of everything
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# Create the win control
	win_screen = Control.new()
	win_screen.visible = false
	canvas_layer.add_child(win_screen)
	
	# Add a semi-transparent background
	var background = ColorRect.new()
	background.color = Color(0, 0, 0.5, 0.7)  # Semi-transparent blue tint
	background.size = Vector2(2000, 2000)
	win_screen.add_child(background)
	
	# Add "YOU WIN!" text
	var win_label = Label.new()
	win_label.text = "YOU WIN!"
	win_label.add_theme_font_size_override("font_size", 96)
	win_label.add_theme_color_override("font_color", Color.WHITE)
	win_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	win_label.position = Vector2(800, 300)
	win_screen.add_child(win_label)
	
	# Add score text
	var final_score_label = Label.new()
	final_score_label.name = "ScoreLabel"  # Give it a name so we can find it later
	final_score_label.add_theme_font_size_override("font_size", 48)
	final_score_label.add_theme_color_override("font_color", Color.WHITE)
	final_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	final_score_label.position = Vector2(800, 450)
	win_screen.add_child(final_score_label)
	
	# Add restart instructions
	var restart_label = Label.new()
	restart_label.text = "Press R to play again"
	restart_label.add_theme_font_size_override("font_size", 36)
	restart_label.add_theme_color_override("font_color", Color.WHITE)
	restart_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	restart_label.position = Vector2(800, 550)
	win_screen.add_child(restart_label)
	
	# Add quit instructions
	var quit_label = Label.new()
	quit_label.text = "Press Q to quit"
	quit_label.add_theme_font_size_override("font_size", 36)
	quit_label.add_theme_color_override("font_color", Color.WHITE)
	quit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quit_label.position = Vector2(800, 600)
	win_screen.add_child(quit_label)

func game_over():
	if is_game_over or is_game_won:
		return
		
	is_game_over = true
	print("GAME OVER!")
	
	# Update the score on the game over screen
	var score_label = game_over_screen.get_node("ScoreLabel")
	if score_label:
		score_label.text = "Final Score: " + str(score)
	
	# Show the game over screen
	game_over_screen.visible = true

func win_game():
	if is_game_over or is_game_won:
		return
		
	is_game_won = true
	print("YOU WIN!")
	
	# Update the score on the win screen
	var score_label = win_screen.get_node("ScoreLabel")
	if score_label:
		score_label.text = "Final Score: " + str(score)
	
	# Show the win screen
	win_screen.visible = true

func _process(_delta):
	# Check for ESC key to quit the game
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		print("ESC key pressed - quitting game")
		get_tree().quit()
	
	# Handle game over restart
	if is_game_over and Input.is_action_just_pressed("ui_select"):  # Space bar
		get_tree().reload_current_scene()  # Restart the game
	
	# Handle win screen controls
	if is_game_won:
		if Input.is_key_pressed(KEY_R):  # R key to restart
			print("R key pressed - restarting game")
			get_tree().reload_current_scene()
		
		if Input.is_key_pressed(KEY_Q):  # Q key to quit
			print("Q key pressed - quitting game")
			get_tree().quit()
	
	# Alternative win condition check every few frames
	if not is_game_won and not is_game_over and Engine.get_physics_frames() % 30 == 0:  # Check every 30 frames
		check_win_condition()
