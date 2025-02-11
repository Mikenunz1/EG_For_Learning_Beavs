extends Node2D

#This string exports to inspector so developers can edit where this SceneChangeNode takes the player
@export var sceneChange :String

#This function activiate ons player entry and calls the scene change from game manager
func _on_area_entered(area):
	if (area.is_in_group("Player")): 
		get_tree().call_group("GameManager", "loadSceneByName", sceneChange)
