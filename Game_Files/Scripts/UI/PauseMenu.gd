extends Control

@onready var resumeButton = $ResumeText/ResumeButton
@onready var quitButton = $QuitText/QuitButton

#Variables to hold AudioStreamPlayers
@onready var menuAudioStream: = $"AudioStreamPlayer-PauseMenuSFX"

#Variables to hold imported audio files for menu sfx
@onready var blip = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx2.mp3")
@onready var select = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx3.mp3")
@onready var exit = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx.mp3")

var pause = false
var open = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_just_pressed("Pause") && !open):
		pause = !pause
		open = true
		openMenu()
		
	elif(Input.is_action_just_pressed("Pause") && open):
		pause = !pause
		open = false
		hideMenu()

func playSound(file):
	menuAudioStream.stream = (file)
	menuAudioStream.play()

func openMenu():
	playSound(blip)
	show()
	resumeButton.disabled = false
	quitButton.disabled = false
	
func hideMenu():
	playSound(blip)
	hide()
	open = false
	resumeButton.disabled = true
	quitButton.disabled = true
	
func quitPressed():
	playSound(exit)
	await get_tree().create_timer(0.2).timeout
	get_tree().call_group("GameManager", "saveGame")
	get_tree().call_group("GameManager", "loadSceneByName", "MainMenu")
