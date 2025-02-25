# Goose.gd
extends CharacterBody2D

const SPEED = 450
var move_direction = Vector2.RIGHT
var move_timer = 0
const DIRECTION_CHANGE_TIME = 2.0  # Change direction every 2 seconds

func _ready():
	# Create collision shape if it doesn't exist
	if !has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(50, 50)  # Adjust based on your goose sprite
		collision.shape = shape
		add_child(collision)
	
	# Set initial position
	position = Vector2(600, 400)
	
	# Add to group for easier detection
	add_to_group("enemies")

func _physics_process(delta):
	# Update movement timer
	move_timer += delta
	
	# Change direction periodically
	if move_timer >= DIRECTION_CHANGE_TIME:
		choose_random_direction()
		move_timer = 0
	
	# Set velocity based on current direction
	velocity = move_direction * SPEED
	
	# Move the goose and handle collisions
	move_and_slide()
	
	# Check for collisions with StaticBody2D
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is StaticBody2D:
			# Get the normal of the collision (direction to bounce away)
			var bounce_direction = collision.get_normal()
			
			# Use the normal to calculate a new direction away from the static body
			move_direction = bounce_direction.normalized()
			
			# Reset the timer so it doesn't immediately change direction again
			move_timer = 0
			
			# Print debug info
			print("Goose collided with StaticBody2D! New direction: ", move_direction)
			break
		elif collider is CharacterBody2D and !collider.is_in_group("enemies"):
			# Assume it's the beaver - trigger game over in World
			var world = get_parent()
			if world.has_method("game_over"):
				world.game_over()
	
	# Check for edge of screen/boundaries
	var screen_size = Vector2(1000, 1000)
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		position = position.clamp(Vector2.ZERO, screen_size)
		choose_random_direction()
	
	# Update sprite orientation
	if has_node("Sprite2D"):
		if move_direction.x < 0:
			$Sprite2D.flip_h = true
		elif move_direction.x > 0:
			$Sprite2D.flip_h = false

func choose_random_direction():
	# Choose a random cardinal direction (no diagonals)
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	# Don't choose the same direction or opposite direction too often
	var old_direction = move_direction
	var new_direction
	
	# Keep trying until we get a direction that's not opposite
	while true:
		new_direction = directions[randi() % directions.size()]
		
		# Don't immediately reverse direction
		if new_direction != -old_direction:
			break
	
	move_direction = new_direction
