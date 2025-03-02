extends Control

@onready var resumeButton = $ResumeText/ResumeButton
@onready var settingsButton = $SettingsText/SettingsButton
@onready var quitButton = $QuitText/QuitButton

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

func openMenu():
	show()
	resumeButton.disabled = false
	settingsButton.disabled = false
	quitButton.disabled = false
	
func hideMenu():
	hide()
	resumeButton.disabled = true
	settingsButton.disabled = true
	quitButton.disabled = true
	
func quitPressed():
	get_tree().call_group("GameManager", "saveGame")
	get_tree().call_group("GameManager", "loadSceneByName", "MainMenu")
