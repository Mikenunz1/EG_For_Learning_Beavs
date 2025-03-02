extends Control

#UI sprite variables
@onready var health1 = $Health1
@onready var health2 = $Health2
@onready var health3 = $Health3
@onready var progress = $Progress

var noHealth = preload("res://Game_Files/Assets/UI/Minigames/Health_Missing.png")
var healthAmount = 3
	
#Called when player hits an obstacle
func decreaseHealth():
	healthAmount = healthAmount - 1
	changeHealthUI()
	
#Funcrion used to update the game UI based on player health
func changeHealthUI():
	if (healthAmount == 2):
		health1.texture = noHealth
		
	if (healthAmount == 1):
		health2.texture = noHealth
		
	if (healthAmount == 0):
		health3.texture = noHealth
		get_tree().call_group("Minigame", "noHealth")

#Function used to update the progress tracker UI		
func updateProgress(val):
	progress.value = 120 - val
	
