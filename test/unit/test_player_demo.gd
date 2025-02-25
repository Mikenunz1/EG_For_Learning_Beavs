extends GutTest


var Level = load('res://Game_Files/Scenes/Functional/GameManager.tscn')

var Player = load('res://Game_Files/Scripts/player_demo.gd')
var GameManager = load('res://Game_Files/Scripts/GameManager.gd')

var _level = null
var p = null
var g = null
var _sender = InputSender.new(Input)

func before_each():
	_level = add_child_autofree(Level.instance())
	p = Player.new()
	wait_frames(1,"WAIT")

func after_each():
	_sender.release_all()
	_sender.clear()

func test_player_exists():
	assert_not_null(p)

func test_level():
	assert_not_null(_level)
	
func test_game_group():
	assert_true(g.is_inside_tree())
	assert_true(g.is_in_group("GameManager"))
	assert_ne(get_tree().get_nodes_in_group("GameManager"),[])

func test_set_player_position():
	p.setPosition(10,15)
	assert_eq(p.global_position.x,10.0)
	assert_eq(p.global_position.y,15.0)
	
func test_set_manager_position():
	p.setPosition(10,15)
	p.sendToManager()
	assert_eq(g.playerX,10.0)
	assert_eq(g.playerY,15.0)

func test_move_right():
	_sender.action_down("Move_Right").hold_for(1)
	simulate(p,1,10)
	p.sendToManager()
	assert_ne(g.playerX,0.0)

	
	
	
