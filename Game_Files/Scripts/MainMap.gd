extends Node2D

@onready var postDam = $PostDam

#Fuction that all scenes have that remove them from tree
func removeSelf():
	queue_free()


func _on_dam_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		print("test")
		get_tree().call_group("GameManager", "checkInventory")

func showDam():
	postDam.show()
	
func hideDam():
	postDam.hide()
