extends GutTest

var Level = load('res://Game_Files/Scenes/Interactive/MinigameSwimming.tscn')

var swimMinigame = load('res://Game_Files/Scripts/MinigameSwimming.gd')
var swimPlayer = load('res://Game_Files/Scripts/PlayerSwimming.gd')

var game = null
var player = null

func before_each():
	#create and add an instance of the minigame	
	game = swimMinigame.new()
	player = swimPlayer.new()
	
	add_child_autofree(game)
	add_child_autofree(player)
	wait_frames(1,"WAIT")

#this function runs after each test
#it cleans up the input sender
func after_each():
	game.removeSelf()
	
#Tests that game exists
func test_game_exists():
	assert_not_null(game)
	assert_true(game.is_inside_tree())
	
#Tests to ensure health resets when game restarts
func test_game_restart():
	game.setHealth(0)
	game.resetHealth()
	assert_eq(game.health, 3)
		
func test_movement():
	
	var playSpeed = player.SPEED
	
	player.stopPlayer()
	assert_eq(player.SPEED, 0)
	
	player.startPlayer()
	assert_eq(player.SPEED, playSpeed)
	
