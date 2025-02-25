# maple_tree.gd
extends StaticBody2D

var hits = 0
const HITS_TO_DESTROY = 5
const POINTS_PER_HIT = 20
var original_scale = Vector2(1, 1)  # Store the original scale

func _ready():
	position = Vector2(350, 300)
	add_to_group("trees")

	
	# Store the original scale when the node is ready
	original_scale = scale
	
	# Make sure we have a collision shape
	if !has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(50, 100)  # Adjust to match your sprite
		collision.shape = shape
		add_child(collision)
	
	print("Maple Tree initialized at ", position)

func take_hit():
	hits += 1
	print("Hit #", hits)
	
	# Add points to the score
	var world = get_parent()
	if world.has_method("add_score"):
		world.add_score(POINTS_PER_HIT)
	
	# Handle scaling and position based on hit count
	if hits < HITS_TO_DESTROY:
		# Calculate new scale (100% -> 80% -> 60% -> 40% -> 20%)
		var scale_percent = 1.0 - (hits * 0.2)  # Reduces by 20% each hit
		scale = original_scale * scale_percent
		
		# Offset
		position.x += -30 
		position.y += 0
		
		# Update collision shape to match new scale
		if has_node("CollisionShape2D"):
			var collision = get_node("CollisionShape2D")
			collision.scale = Vector2(1, 1) / scale_percent  # Inverse scaling to maintain collision
	else:
		# Tree is destroyed after 5 hits
		queue_free()  # Remove the tree from the scene
