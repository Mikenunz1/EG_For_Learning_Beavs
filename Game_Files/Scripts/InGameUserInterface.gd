extends Control

@onready var map = $MapUI
@onready var player = $MapUI/PlayerIcon

#THESE ARE TEMP VARIABLES BASED AROUND THE CURRENT MAP UI
var UIoriginX = 481
var UIoriginY = 285

#Minimap functionality variables -----------------------------------------------

#These store the player's world map location
var playerWorldX = 0
var playerWorldY = 0

#Minimap UI functionality ------------------------------------------------------
var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_map_button_pressed():
	if (open):
		map.hide()
		open = false
			
	else:	
		map.show()
		get_tree().call_group("GameManager", "updateMapUI")
		set_player_location()
		open = true

#Used by game manager to set the player location locally to the map
func setPlayerWorldPosition(x, y):
	playerWorldX = x
	playerWorldY = y
	
#Function used by UI to determine where to place the player on the map
func set_player_location():
	#TODO FIX this function based on map and proper variables
	player.global_position.x = UIoriginX + playerWorldX * 0.1
	player.global_position.y = UIoriginY + playerWorldY * 0.1
