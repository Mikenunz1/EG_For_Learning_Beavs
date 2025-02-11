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
var ForestScene = preload("res://Game_Files/Scenes/Environmental/Forest.tscn")

#GM1b: Raw Variables tracked by the game manager throughout runtime --------------------------------
var playerX = 0
var playerY = 0

var playerScene = ""

#Settings Variables
#var resolutionWidth = 0
#var resolutionHeight = 0

#GM2a : Ready and Process --------------------------------------------------------------------------

#Called on game startup when game manager finishes loading in 
func _ready():
	loadSceneByName("MainMenu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#GM2b : Load and save functions --------------------------------------------------------------------

#This function is used for loading based on name, typically when user traverses maps
func loadSceneByName(sceneName):
	
	var sceneSpecifier
	get_tree().call_group("GameScene", "removeSelf")
	
	playerScene = sceneName
	
	#Checks name for specific scene 
	match sceneName:
		"MainMenu":
			sceneSpecifier = MainMenu
			
		"Forest":
			sceneSpecifier = ForestScene
		
	var instance = sceneSpecifier.instantiate()
	instance.position = Vector2(0,0)
	add_child(instance)
	
#This function is used for loading a scene based off of a save file. 
func loadSceneByFile():
	#Error Checking to ensure file exists 
	if (!FileAccess.file_exists("user://gameSave.save")):
		return #Error, no file by that name exists 
		
	#TESTING THESE STILL
	var gameSave = FileAccess.open("user://gameSave.save", FileAccess.READ)
	var json_string = gameSave.get_line()	
	var json = JSON.new()	
	var parse_result = json.parse(json_string)
	var dict_data = json.data 
	
	#After data has been processed
	playerX = dict_data["pos_x"]
	playerY = dict_data["pos_y"]
	playerScene = dict_data["scene"]	
	
	loadSceneByName(playerScene)
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
		"scene" : playerScene
	}

	#Saving for the game scene elements
	var jsonGame = JSON.stringify(gameDict)
	gameSave.store_line(jsonGame)

#GM2c Data updating functions ----------------------------------------------------------------------

#This function is used to pass player location data to the game manager
func updatePlayerLocation(x, y):
	playerX = x
	playerY = y
