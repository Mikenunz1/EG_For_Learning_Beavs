extends GutTest

var Level = load('res://Game_Files/Scenes/Interactive/MinigameSwimming.tscn')

var swimMinigame = load("res://Game_Files/Scenes/Interactive/MinigameSwimming.tscn")
var swimPlayer = load("res://Game_Files/Scenes/Player/PlayerSwimming.tscn")

var game = null
var player = null

var _sender = InputSender.new(Input)

func before_each():
	#create and add an instance of the minigame	
	game = swimMinigame.instantiate()
	player = swimPlayer.instantiate()
	
	add_child_autofree(game)
	add_child_autofree(player)
	wait_frames(1,"WAIT")

#this function runs after each test
#it cleans up the input sender
func after_each():
	_sender.release_all()
	_sender.clear()
	game.removeSelf()
		
func test_movement_audio():
	
	_sender.action_down("Move_Up").hold_for(1) #hold down the action for 1 sec
	simulate(player, 1.0, 10) #simulate that action on the player
	assert_eq(player.movementAudioStreamPlayer.playing, true)
	
