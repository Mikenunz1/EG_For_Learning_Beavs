extends GutTest

var Player = load("res://Game_Files/Scenes/Player/PlayerInGame.tscn")
var Map = load("res://Game_Files/Scenes/Environmental/main_map.tscn")

var p = null
var map = null
var _sender = InputSender.new(Input)

const COLLISION_TOLERANCE = 50.0
const MOVE_DURATION = 2.0
const PHYSICS_STEPS = 0.1

# function runs before each test
func before_each():
	map = Map.instantiate()
	add_child_autofree(map)
	p = Player.instantiate()
	add_child_autofree(p)
	wait_frames(15)

# function runs after each test
func after_each():
	_sender.release_all()
	_sender.clear()

# tests collision for right wall
func test_right_boundary():
	# positions player near wall and player moves towards wall
	var boundary = 27814.6
	p.global_position = Vector2(boundary - 500, 200)
	print("Starting position: ", p.global_position)
	print("Expected boundary: ", boundary)
	
	_sender.action_down("Move_Right").hold_for(MOVE_DURATION)
	
	simulate(p, MOVE_DURATION, PHYSICS_STEPS)
	# check player is within boundaries/collided with wall
	var final_pos = p.global_position
	print("Final position: ", final_pos)
	
	assert_lt(final_pos.x, boundary + COLLISION_TOLERANCE,
		"Should stop before right boundary (Actual: %s, Allowed: %s)" % [final_pos.x, boundary + COLLISION_TOLERANCE])
	assert_gt(final_pos.x, boundary - 500,
		"Should move towards boundary (Actual: %s, Expected > %s)" % [final_pos.x, boundary - 500])

#tests collisions for left wall
func test_left_boundary():
	# positions player near wall and player moves towards wall
	var boundary = 16.75
	p.global_position = Vector2(boundary + 500, 200)
	print("Starting position: ", p.global_position)
	print("Expected boundary: ", boundary)
	_sender.action_down("Move_Left").hold_for(MOVE_DURATION)
	simulate(p, MOVE_DURATION, PHYSICS_STEPS)
	# check player is within boundaries/collided with wall
	var final_pos = p.global_position
	print("Final position: ", final_pos)

	assert_gt(final_pos.x, boundary - COLLISION_TOLERANCE,
		"Should stop before left boundary (Actual: %s, Allowed: %s)" % [final_pos.x, boundary - COLLISION_TOLERANCE])
	assert_lt(final_pos.x, boundary + 500,
		"Should move left (Actual: %s, Expected < %s)" % [final_pos.x, boundary + 500])

# tests collisions for top boundary
func test_top_boundary():
	# positions player near wall and player moves towards wall
	var boundary = 9.0
	p.global_position = Vector2(200, boundary + 500)
	print("Starting position: ", p.global_position)
	print("Expected boundary: ", boundary)
	
	_sender.action_down("Move_Up").hold_for(MOVE_DURATION)
	simulate(p, MOVE_DURATION, PHYSICS_STEPS)
	# check player is within boundaries/collided with wall
	var final_pos = p.global_position
	print("Final position: ", final_pos)
	assert_gt(final_pos.y, boundary - COLLISION_TOLERANCE,
		"Should stop before top boundary (Actual: %s, Allowed: %s)" % [final_pos.y, boundary - COLLISION_TOLERANCE])
	assert_lt(final_pos.y, boundary + 500,
		"Should move up (Actual: %s, Expected < %s)" % [final_pos.y, boundary + 500])

# tests collisions for bottom boundary
func test_bottom_boundary():
	# positions player near wall and player moves towards wall
	var boundary = 6388.0
	p.global_position = Vector2(200, boundary - 500)
	print("Starting position: ", p.global_position)
	print("Expected boundary: ", boundary)
	_sender.action_down("Move_Down").hold_for(MOVE_DURATION)
	simulate(p, MOVE_DURATION, PHYSICS_STEPS)
	# check player is within boundaries/collided with wall
	var final_pos = p.global_position

	print("Final position: ", final_pos)
	
	assert_lt(final_pos.y, boundary + COLLISION_TOLERANCE,
		"Should stop before bottom boundary (Actual: %s, Allowed: %s)" % [final_pos.y, boundary + COLLISION_TOLERANCE])
	assert_gt(final_pos.y, boundary - 500,
		"Should move down (Actual: %s, Expected > %s)" % [final_pos.y, boundary - 500])
