extends Area2D

func _on_body_entered(body):
	if body is Player:
		call_deferred("startMinigame")

func startMinigame():
	get_tree().call_group("GameManager", "saveGame")
	get_tree().call_group("GameManager", "loadSceneByName", "MinigameSwimming")

	
