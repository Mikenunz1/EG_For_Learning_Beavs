extends GutTest

var Level = load('res://Game_Files/Scenes/Functional/GameManager.tscn')

var Player = load("res://Game_Files/Scenes/Player/PlayerInGame.tscn")
var GameManager = load("res://Game_Files/Scenes/Functional/GameManager.tscn")

var p = null
var g = null
var _sender = InputSender.new(Input)

#this function runs before each test function
#it sets up prerequisite assumptions for each test
func before_each():
	#create and add an instance of player and game manager to scene tree
	p = Player.instantiate()
	g = GameManager.instantiate()
	add_child_autofree(p)
	add_child_autofree(g)
	wait_frames(1,"WAIT")

#this function runs after each test
#it cleans up the input sender
func after_each():
	_sender.release_all()
	_sender.clear()

#test player movement to the right
func test_movement_audio():
	_sender.action_down("Move_Right").hold_for(1) #hold down the action for 1 sec
	simulate(p, 1.0, 10) #simulate that action on the player
	_sender.action_up("Move_Right") #release the action
	p.sendToManager() #send positional update to game manager
	assert_eq(p.playerWalkingAudioStream.playing, true) 
