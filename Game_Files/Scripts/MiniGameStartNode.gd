extends Area2D

@onready var tSprite = $TracksSprite

@export var gameID = -1
var gameSpecifer = ""

func _ready():
	tSprite.play("default")

func _on_area_entered(area):
	if(area.is_in_group("Player")):
		call_deferred("startMinigame")

func startMinigame():
	
	match gameID:
		1:
			gameSpecifer = "MinigameSwimming"
		2:
			gameSpecifer = "MinigameTreeCutting"
			
	get_tree().call_group("GameManager", "saveGame")
	get_tree().call_group("GameManager", "loadSceneByName", gameSpecifer)

	
