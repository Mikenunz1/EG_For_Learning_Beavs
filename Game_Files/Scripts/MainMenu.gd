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
@onready var resolutionChoice = $SettingsMenu/ResolutionsDropdown
@onready var textSizeChoice = $SettingsMenu/TextSizeDropdown

#Variables to hold AudioStreamPlayers
@onready var menuAudioStream: = $"AudioStreamPlayer-MenuSFX"

#Variables to hold imported audio files for menu sfx
@onready var blip = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx2.mp3")
@onready var select = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx3.mp3")
@onready var exit = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/menu-sfx.mp3")

func playSound(file):
	menuAudioStream.stream = (file)
	menuAudioStream.play()

func newGamePressed():
	#This is a temporary scenechange until we have a proper first scene
	playSound(select)
	await get_tree().create_timer(0.1).timeout
	get_tree().call_group("GameManager", "loadSceneByName", "MainMap")
	
func loadGamePressed():
	#This is a temporary scencehange until we have a proper load sequence
	playSound(select)
	await get_tree().create_timer(0.1).timeout
	get_tree().call_group("GameManager", "loadSceneByFile")
	
func onlinePressed():
	playSound(blip)
	await get_tree().create_timer(0.1).timeout
	pass
	
func settingsPressed():
	playSound(select)
	await get_tree().create_timer(0.1).timeout
	hideStartMenu()
	showSettingsMenu()
	
#This functions exits the game. It does not save any data as that functionality happens within game
func quitPressed():
	playSound(exit)
	await get_tree().create_timer(0.2).timeout
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
	playSound(exit)
	get_tree().call_group("GameManager", "saveSettings")
	showStartMenu()

func showSettingsMenu():
	get_tree().call_group("GameManager", "setSelected")
	settingsMenu.show()
	settingsBackButton.disabled = false
	
#Fuction that all scenes have that remove them from tree
func removeSelf():
	queue_free()
	
func setProperty(settingName, val):
	match settingName:
		"resolution": 
			resolutionChoice.selected = val
		"textSize":
			textSizeChoice.selected = val
	
