extends Node2D
#                     GAME MANAGER OVERVIEW                       #
# --------------------------------------------------------------- #
# 1. Variables and Variable Tracking                              #
#    a. Preloads                                                  #
#    b. Raw Variables                                             #
# 2. Function                                                     #
#    a. Ready and Process                                         # 
#    b. Load and Saving                                           #
#    c. Data Updating                                             #

#GM1a : Preloads for specific scenes ---------------------------------------------------------------
var MainMenu = preload("res:///Game_Files/Scenes/UI/MainMenu.tscn")
var MainMap = preload("res://Game_Files/Scenes/Environmental/main_map.tscn")
var MinigameSwimming = preload("res://Game_Files/Scenes/Interactive/MinigameSwimming.tscn")
var MinigameTreeCutting = preload("res://Game_Files/Scenes/Interactive/MinigameTreeCutting.tscn")

#GM1b: Raw Variables tracked by the game manager throughout runtime --------------------------------

#Ingame Variables
var playerX = 0
var playerY = 0
var playerScene = ""

var branchCount = 0
var rockCount = 0

var storyBlock = 0

#Settings Variables
var resolutionSelection = 0
var textsizeSelection = 0
var masterVolume = 0.0
var soundVolume = 0.0
var musicVolume = 0.0

#GM2a : Ready and Process --------------------------------------------------------------------------

#Called on game startup when game manager finishes loading in 
func _ready():
	add_to_group("GameManager")
	loadSceneByName("MainMenu")
	loadSettings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#GM2b : Load and save functions --------------------------------------------------------------------

#This function is used for loading the saved settings
func loadSettings():
	#Checking if settings have been saved before
	if (!FileAccess.file_exists("user://gameSettings.save")):
		return #Error, no file by that name exists 
		
	var settingsSave = FileAccess.open("user://gameSettings.save", FileAccess.READ)
	var json_string = settingsSave.get_line()	
	var json = JSON.new()	
	var _parse_result = json.parse(json_string)
	var dict_data = json.data 
	
	#After data has been processed
	resolutionSelection = dict_data["resolution"]
	textsizeSelection = dict_data["textSize"]
	
	get_tree().call_group("Settings", "setGameResolution", resolutionSelection)

#This function is used for loading based on name, typically when user traverses maps
func loadSceneByName(sceneName):
	
	var sceneSpecifier
	get_tree().call_group("GameScene", "removeSelf")
	
	playerScene = sceneName
	
	#Checks name for specific scene 
	match sceneName:
		"MainMenu":
			sceneSpecifier = MainMenu
			
		"MainMap":
			sceneSpecifier = MainMap
			
		"MinigameSwimming":
			sceneSpecifier = MinigameSwimming
			
		"MinigameTreeCutting":
			sceneSpecifier = MinigameTreeCutting
		
	var instance = sceneSpecifier.instantiate()
	instance.position = Vector2(0,0)
	add_child(instance)
	
#This function is used for loading a scene based off of a save file. 
func loadSceneByFile():
	#Error Checking to ensure file exists 
	if (!FileAccess.file_exists("user://gameSave.save")):
		return #Error, no file by that name exists 
		
	var gameSave = FileAccess.open("user://gameSave.save", FileAccess.READ)
	var json_string = gameSave.get_line()	
	var json = JSON.new()	
	var _parse_result = json.parse(json_string)
	var dict_data = json.data 
	
	#After data has been processed
	playerX = dict_data["pos_x"]
	playerY = dict_data["pos_y"]
	playerScene = dict_data["scene"]	
	rockCount = dict_data["rocks"]
	branchCount = dict_data["branches"]
	
	print(branchCount)
	
	loadSceneByName(playerScene)
	get_tree().call_group("InGameUI", "setRocks", rockCount)
	get_tree().call_group("InGameUI", "setBranches", branchCount)
	get_tree().call_group("Player", "setPosition", playerX, playerY)
	
#This function is called whenever a key event happens, a scene change, or on game quit.
func saveGame():
	
	get_tree().call_group("GameComponent", "sendToManager")
	
	var gameSave = FileAccess.open("user://gameSave.save", FileAccess.WRITE)
	
	#Variable Dictionaries: Sets of dictionaries for saving game data
	#Game Data Dictionary
	var gameDict = {
		"pos_x" : playerX,
		"pos_y" : playerY,
		"scene" : playerScene,
		"rocks" : rockCount,
		"branches" : branchCount
	}

	#Saving for the game scene elements
	var jsonGame = JSON.stringify(gameDict)
	gameSave.store_line(jsonGame)

#Called whenever exiting the settings menu
func saveSettings():
	var settingsSave = FileAccess.open("user://gameSettings.save", FileAccess.WRITE)
	
	var settingsDict = {
		"resolution" : resolutionSelection,
		"textSize" : textsizeSelection
	}
	
	#Saving for the game settings elements
	var jsonSettings = JSON.stringify(settingsDict)
	settingsSave.store_line(jsonSettings)

#GM2c Data updating functions ----------------------------------------------------------------------

#This function is used to pass player location data to the game manager
func updatePlayerLocation(x, y):
	playerX = x
	playerY = y
	
func setPlayerScene(newName):
	playerScene = newName
	
func addRock():
	if (rockCount < 4):
		rockCount = rockCount + 1
		get_tree().call_group("InGameUI", "setRocks", rockCount)
	
func addBranch():
	if (branchCount < 4):
		branchCount = branchCount + 1
		get_tree().call_group("InGameUI", "setBranches", branchCount)

#This function is used to pass resolution settings to the game manager
func updateResolution(val):
	resolutionSelection = val
	
#This function is used to pass text size settings to the game manager
func updateTextSize(val):
	textsizeSelection = val
	
#This function is used set the selected choices that appear in the settings menu
func setSelected():
	get_tree().call_group("MainMenu", "setProperty", "resolution", resolutionSelection)
	get_tree().call_group("MainMenu", "setProperty", "textSize", textsizeSelection)
	
#This function is used to update the ingame minimap player marker
func updateMapUI():
	get_tree().call_group("Player", "sendToManager")
	get_tree().call_group("InGameUI", "setPlayerWorldPosition", playerX, playerY)
