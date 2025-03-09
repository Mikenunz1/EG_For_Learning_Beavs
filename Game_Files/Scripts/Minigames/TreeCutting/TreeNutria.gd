# Nutria.gd
extends CharacterBody2D
var SPEED = 450
var move_direction = Vector2.RIGHT
var move_timer = 0
var paused = false
const DIRECTION_CHANGE_TIME = 1.0  # Change direction every second

func _ready():
	# Create collision shape if it doesn't exist
	if !has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(50, 50)  # Adjust based on your nutria sprite
		collision.shape = shape
		add_child(collision)

func _physics_process(delta):
	# Update movement timer
	
	if (!paused):
		move_timer += delta
	
	# Change direction periodically
	if move_timer >= DIRECTION_CHANGE_TIME:
		choose_random_direction()
		move_timer = 0
	
	# Set velocity based on current direction
	velocity = move_direction * SPEED
	
	# Move the nutria and handle collisions
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
			print("Nutria collided with StaticBody2D! New direction: ", move_direction)
			break
		elif collider is CharacterBody2D and !collider.is_in_group("enemies"):
			# Assume it's the beaver - trigger game over in World
			var world = get_parent()
			if world.has_method("game_over"):
				world.game_over()
	
	# For nutria, we need to flip the sprite in the OPPOSITE way compared to beaver
	if has_node("Sprite2D"):
		if move_direction.x < 0:
			# Moving left, sprite should face LEFT
			$Sprite2D.flip_h = false
		elif move_direction.x > 0:
			# Moving right, sprite should face RIGHT
			$Sprite2D.flip_h = true

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
	
func stop_movement():
	SPEED = 0
	paused = true
	
func start_movement():
	SPEED = 400
	paused = false
	
func remove_self():
	queue_free()
