extends GutTest

var Level = load('res://Game_Files/Scenes/Functional/GameManager.tscn')

var Player = load('res://Game_Files/Scripts/player_demo.gd')
var GameManager = load('res://Game_Files/Scripts/GameManager.gd')

var p = null
var g = null
var _sender = InputSender.new(Input)

#this function runs before each test function
#it sets up prerequisite assumptions for each test
func before_each():
	#create and add an instance of player and game manager to scene tree
	p = Player.new()
	g = GameManager.new()
	
	add_child_autofree(p)
	add_child_autofree(g)
	wait_frames(1,"WAIT")

#this function runs after each test
#it cleans up the input sender
func after_each():
	_sender.release_all()
	_sender.clear()

#test whether p exists and is in the SceneTree
func test_player_exists():
	assert_not_null(p)
	assert_true(p.is_inside_tree())

#test whether g exists, is in the SceneTree, and is in the "GameManager" group
func test_game_group():
	assert_not_null(g)
	assert_true(g.is_inside_tree())
	assert_true(g.is_in_group("GameManager"))
	assert_ne(get_tree().get_nodes_in_group("GameManager"),[])

#test directly setting player position
func test_set_player_position():
	p.setPosition(10,15)
	assert_eq(p.global_position.x,10.0)
	assert_eq(p.global_position.y,15.0)

#test sendToManager() emitter to GameManager object
func test_set_manager_position():
	p.setPosition(10,15)
	p.sendToManager()
	assert_eq(g.playerX,10.0)
	assert_eq(g.playerY,15.0)

#test player movement to the right
func test_move_right():
	_sender.action_down("Move_Right").hold_for(1) #hold down the action for 1 sec
	simulate(p, 1.0, 10) #simulate that action on the player
	_sender.action_up("Move_Right") #release the action
	p.sendToManager() #send positional update to game manager
	assert_ne(g.playerX,0.0) 

#test player movement to the left
func test_move_left():
	_sender.action_down("Move_Left").hold_for(1)
	simulate(p, 1.0, 10)
	_sender.action_up("Move_Left")
	p.sendToManager()
	assert_ne(g.playerX,0.0)

#test player movement down
func test_move_down():
	_sender.action_down("Move_Down").hold_for(1)
	simulate(p, 1.0, 10)
	_sender.action_up("Move_Down")
	p.sendToManager()
	assert_ne(g.playerY,0.0)	

#test player movement up
func test_move_up():
	_sender.action_down("Move_Up").hold_for(1)
	simulate(p, 1.0, 10)
	_sender.action_up("Move_Up")
	p.sendToManager()
	assert_ne(g.playerY,0.0)	
