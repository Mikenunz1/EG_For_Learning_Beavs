extends Control

@onready var inv = $InvUI

@onready var map = $MapUI
@onready var player = $MapUI/PlayerIcon

#THESE ARE TEMP VARIABLES BASED AROUND THE CURRENT MAP UI
var UIoriginX = 640
var UIoriginY = 280

#Minimap functionality variables -----------------------------------------------

#These store the player's world map location
var playerWorldX = 0
var playerWorldY = 0

# UI functionality ------------------------------------------------------
var menuOpen = false
var mapOpen = false
var invOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_map_button_pressed():
	
	if (mapOpen):
		map.hide()
		mapOpen = false
		menuOpen = false
		
	elif (!menuOpen):
		map.show()
		get_tree().call_group("GameManager", "updateMapUI")
		set_player_location()
		mapOpen = true
		menuOpen = true

func _on_inv_button_pressed():
	if (invOpen):
		inv.hide()
		invOpen = false
		menuOpen = false
			
	elif (!menuOpen):
		inv.show()
		invOpen = true
		menuOpen = true
		
#Used by game manager to set the player location locally to the map
func setPlayerWorldPosition(x, y):
	playerWorldX = x
	playerWorldY = y
		
#Function used by UI to determine where to place the player on the map
func set_player_location():
	#TODO FIX this function based on map and proper variables
	
	player.position.x = UIoriginX + playerWorldX * 0.03449
	player.position.y = UIoriginY + playerWorldY * 0.03449
	
	print("Player in game position :")
	print(playerWorldX)
	
	print("UI Map position:")
	print(player.position.x)
