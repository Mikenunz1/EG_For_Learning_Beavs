extends GutTest

var Level = load('res://Game_Files/Scenes/Interactive/MinigameSwimming.tscn')

var swimMinigame = load('res://Game_Files/Scripts/MinigameSwimming.gd')

var _sender = InputSender.new(Input)

var game = null

func before_each():
	#create and add an instance of the minigame
	#game = swimMinigame.new()
	
	game = Level.instantiate()
	get_tree().current_scene.add_child(game)

	wait_frames(1,"WAIT")

#this function runs after each test
#it cleans up the input sender
func after_each():
	_sender.release_all()
	_sender.clear()
	game.removeSelf()
	
#Tests that game exists
func test_game_exists():
	assert_not_null(game)
	assert_true(game.is_inside_tree())
	
#Tests to ensure health resets when game restarts
func test_game_restart():
	game.setHealth(0)
	game.restart()
	game.pause()
	assert_eq(game.health, 3)
	
func test_game_win():
	game.game_win()
	assert_eq(game.win, true)
	
func test_pause():
	var timeStart = game.timer.time_left
	game.pause()
	var timeEnd = game.timer.time_left
	var timeDifference = timeStart - timeEnd
	var pauseCheck = false
	
	if (timeDifference < 0.1):
		pauseCheck = true
	
	assert_eq(true, pauseCheck)
	
