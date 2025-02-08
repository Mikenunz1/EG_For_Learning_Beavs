extends Control

#Variables for specifc menus
@onready var mainMenu = $StartMenu
@onready var settingsMenu = $SettingsMenu

#Variables for the specific buttons in the start menu
@onready var newGameButton = $StartMenu/NewText/NewButton
@onready var loadGameButton = $StartMenu/LoadText/LoadButton
@onready var onlineButton = $StartMenu/OnlineText/OnlineButton
@onready var settingsButton = $StartMenu/SettingsText/SettingsButton
@onready var quitGameButton = $StartMenu/QuitText/QuitButton

#Variables for the specific buttons in the settings memu
@onready var settingsBackButton = $SettingsMenu/BackText/BackButton

func newGamePressed():
	#This is a temporary scenchange until we have a proper first scene
	get_tree().change_scene_to_file("res://Game_Files/Scenes/Player/Player_Demo.tscn")
	
func loadGamePressed():
	#This is a temporary scenchange until we have a proper load sequence
	get_tree().change_scene_to_file("res://Game_Files/Scenes/Player/Player_Demo.tscn")
	
func onlinePressed():
	pass
	
func settingsPressed():
	hideStartMenu()
	showSettingsMenu()
	
#This functions exits the game. It does not save any data as that functionality happens within game
func quitPressed():
	get_tree().quit()
	
#This function is used to hide and disable the main menu whenever another menu is open
func hideStartMenu():
	mainMenu.hide()
	newGameButton.disabled = true
	loadGameButton.disabled = true
	onlineButton.disabled = true
	settingsButton.disabled = true
	quitGameButton.disabled = true
	
#This function is used to show and enable the main menu whenever another menu is closed
func showStartMenu():
	mainMenu.show()
	newGameButton.disabled = false
	loadGameButton.disabled = false
	onlineButton.disabled = false
	settingsButton.disabled = false
	quitGameButton.disabled = false

func hideSettingsMenu():
	settingsMenu.hide()
	settingsBackButton.disabled = true
	showStartMenu()

func showSettingsMenu():
	settingsMenu.show()
	settingsBackButton.disabled = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
