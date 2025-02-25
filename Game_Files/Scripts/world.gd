# World.gd
extends Node2D

var score = 0
var score_label
var game_over_screen
var is_game_over = false


func _ready():
	# Set window size to 2000x2000
	DisplayServer.window_set_size(Vector2i(2000, 2000))
	# Create background using ground.png
	var background = Sprite2D.new()
	var texture = load("res://ground.png")  # Make sure the path is correct
	background.texture = texture
	
	# Center the background
	background.position = Vector2(1000, 1000)  # Center of the 2000x2000 window
	# Get the original texture size
	var texture_size = texture.get_size()
	print("Original texture size: ", texture_size)
	
	# Calculate scale to make it exactly 2000x2000
	var scale_x = 2000.0 / texture_size.x
	var scale_y = 2000.0 / texture_size.y
	background.scale = Vector2(scale_x, scale_y)
	
	print("Applied scale: ", background.scale)
	# Scale the background to fit if needed (optional)
	# Uncomment and adjust these lines if needed:
	# var screen_size = Vector2(2000, 2000)
	# background.scale = screen_size / texture.get_size()
	
	add_child(background)
	move_child(background, 0)  # Ensure it's at the back)
	
	# Create score label with custom font
	setup_score_label()
	
	# Create game over screen but don't show it yet
	create_game_over_screen()


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
	if is_game_over:
		return
		
	score += points
	score_label.text = "Score: " + str(score)

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

func game_over():
	if is_game_over:
		return
		
	is_game_over = true
	print("GAME OVER!")
	
	# Update the score on the game over screen
	var score_label = game_over_screen.get_node("ScoreLabel")
	if score_label:
		score_label.text = "Final Score: " + str(score)
	
	# Show the game over screen
	game_over_screen.visible = true

func _process(_delta):
	# Check for ESC key to quit the game
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		print("ESC key pressed - quitting game")
		get_tree().quit()
	
	if is_game_over and Input.is_action_just_pressed("ui_select"):  # Space bar
		get_tree().reload_current_scene()  # Restart the game
