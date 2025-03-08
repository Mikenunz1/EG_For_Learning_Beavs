# Beaver.gd
extends CharacterBody2D

var last_direction = 1  # 1 for right, -1 for left
const SPEED = 600

func _ready():
	
	
	# Make sure beaver has collision
	if !has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(50, 50)  # Adjust to match your sprite
		collision.shape = shape
		add_child(collision)
	
func _physics_process(_delta):
	# Get horizontal and vertical input
	var h_direction = Input.get_axis("Move_Left", "Move_Right")
	var v_direction = Input.get_axis("Move_Up", "Move_Down")
	
	# Set velocity based on input
	velocity.x = h_direction * SPEED
	velocity.y = v_direction * SPEED
	
	# Remember last horizontal direction for sprite orientation
	if h_direction != 0:
		last_direction = h_direction
	
	move_and_slide()
	
	# Update sprite direction based on last_direction, not current movement
	if has_node("Sprite2D"):
		$Sprite2D.flip_h = last_direction < 0
	
	if Input.is_action_just_pressed("Action"):
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("trees"):
				collider.take_hit()

func _on_scripting_area_entered(area):
	print("Area entered")
	if (area.is_in_group("enemies")):
		print("Game Over")
		get_tree().call_group("Minigame", "game_over")	
		
func remove_self():
	queue_free()
