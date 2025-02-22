extends GutTest

var Player = load('res://Game_Files/Scripts/player_demo.gd')
var GameManager = load('res://Game_Files/Scripts/GameManager.gd')

func test_player_exists():
	var p = Player.new()
	assert_not_null(p)

func test_game_manager():
	var g = GameManager.new()
	assert_not_null(g)

func test_set_global_position():
	var p = Player.new()
	p.setPosition(10,15)
	assert_eq(p.global_position.x,10)
	assert_eq(p.global_position.y,15)

"""
func test_set_position():
	var p = Player.new()
	var g = GameManager.new()
	p.setPosition(10,15)
	p.sendToManager()
	assert_eq(g.playerX,10)
	assert_eq(g.playerY,15)
"""
