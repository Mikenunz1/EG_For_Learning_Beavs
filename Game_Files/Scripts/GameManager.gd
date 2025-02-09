extends Node2D

#Variable Tracking: Key Variables that the game manager is in charge of tracking
var MainMenu = preload("res:///Game_Files/Scenes/UI/MainMenu.tscn")
var ForestScene = preload("res://Game_Files/Scenes/Environmental/Forest.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	loadSceneByName("MainMenu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#This function is used for loading a new based soley on the name of the scene, most used for player traversal
func loadSceneByName(name):
	
	var sceneSpecifier
	get_tree().call_group("GameScene", "removeSelf")
	
	#Checks name for specific scene 
	match name:
		"MainMenu":
			sceneSpecifier = MainMenu
			var instance = sceneSpecifier.instantiate()
			
		"Forest":
			sceneSpecifier = ForestScene
			var instance = sceneSpecifier.instantiate()
		
	var instance = sceneSpecifier.instantiate()
	instance.position = Vector2(0,0)
	add_child(instance)
	
#This function is used for loading a scene based off of a save file. 
func loadSceneByFile():
	pass
