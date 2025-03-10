extends Control

@onready var inv = $InvUI

@onready var map = $MapUI
@onready var player = $MapUI/PlayerIcon
@onready var sticksUI = $InvUI/Sticks
@onready var rocksUI = $InvUI/Rocks

var sticks1 = load("res://Game_Files/Assets/UI/Sticks_1.png")
var sticks2 = load("res://Game_Files/Assets/UI/Sticks_2.png")
var sticks3 = load("res://Game_Files/Assets/UI/Sticks_3.png")
var sticks4 = load("res://Game_Files/Assets/UI/Sticks_4.png")

var rocks1 = load("res://Game_Files/Assets/UI/Rocks_1.png")
var rocks2 = load("res://Game_Files/Assets/UI/Rocks_2.png")
var rocks3 = load("res://Game_Files/Assets/UI/Rocks_3.png")
var rocks4 = load("res://Game_Files/Assets/UI/Rocks_4.png")

var branches = 0
var rocks = 0

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
	pass

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
		updateInvUI(branches, rocks)
		inv.show()
		invOpen = true
		menuOpen = true
		
#Used by game manager to set the player location locally to the map
func setPlayerWorldPosition(x, y):
	playerWorldX = x
	playerWorldY = y
		
#Function used by UI to determine where to place the player on the map
func set_player_location():
	
	player.position.x = UIoriginX + playerWorldX * 0.03449
	player.position.y = UIoriginY + playerWorldY * 0.03449

func setBranches(val):
	branches = val
	
func setRocks(val):
	rocks = val

func updateInvUI(stickVal, rockVal):
	
	if (stickVal == 1):
		sticksUI.texture = sticks1
		
	elif (stickVal == 2):
		sticksUI.texture = sticks2
	
	elif (stickVal == 3):
		sticksUI.texture = sticks3
	
	elif (stickVal == 4):
		sticksUI.texture = sticks4
		
	if (rockVal == 1):
		rocksUI.texture = rocks1
		
	elif (rockVal == 2):
		rocksUI.texture = rocks2
	
	elif (rockVal == 3):
		rocksUI.texture = rocks3
	
	elif (rockVal == 4):
		rocksUI.texture = rocks4
