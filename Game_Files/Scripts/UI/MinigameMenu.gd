extends Control

@onready var resumeButton = $ResumeText/ResumeButton
@onready var quitButton = $QuitText/QuitButton

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	resumeButton.disabled = true
	quitButton.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("Pause")):
		if (open):
			hideMenu()
			open = false
		else:
			openMenu()
			open = true
		

func openMenu():
	show()
	resumeButton.disabled = false
	quitButton.disabled = false
	pause()
	open = true
	
func hideMenu():
	hide()
	resumeButton.disabled = true
	quitButton.disabled = true
	unpause()
	open = false
	
func pause():
	get_tree().call_group("Minigame", "pause")
	
func unpause():
	get_tree().call_group("Minigame", "unpause")
	
func quit():
	get_tree().call_group("Minigame", "gameExit")
