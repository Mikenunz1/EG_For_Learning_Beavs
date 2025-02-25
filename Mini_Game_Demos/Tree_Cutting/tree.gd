# Tree.gd
extends StaticBody2D

var hits = 0
const HITS_TO_DESTROY = 5
const POINTS_PER_HIT = 20

func _ready():
	position = Vector2(350, 200)
	add_to_group("trees")
	
	# Make sure we have a collision shape
	if !has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(50, 100)  # Adjust to match your sprite
		collision.shape = shape
		add_child(collision)
	
	# Set up initial visibility - only layer1 is visible at start
	if has_node("Layer1"): $Layer1.visible = true
	if has_node("Layer2"): $Layer2.visible = false
	if has_node("Layer3"): $Layer3.visible = false
	if has_node("Layer4"): $Layer4.visible = false
	if has_node("Layer5"): $Layer5.visible = false
	
	print("Tree initialized at ", position)

func take_hit():
	hits += 1
	print("Hit #", hits)
	
	# Add points to the score
	var world = get_parent()
	if world.has_method("add_score"):
		world.add_score(POINTS_PER_HIT)
	
	# Hide current layer and show next layer
	match hits:
		1:
			if has_node("Layer1"): $Layer1.visible = false
			if has_node("Layer2"): $Layer2.visible = true
		2:
			if has_node("Layer2"): $Layer2.visible = false
			if has_node("Layer3"): $Layer3.visible = true
		3:
			if has_node("Layer3"): $Layer3.visible = false
			if has_node("Layer4"): $Layer4.visible = true
		4:
			if has_node("Layer4"): $Layer4.visible = false
			if has_node("Layer5"): $Layer5.visible = true
		5:
			queue_free()  # Remove tree after all layers are gone
