extends Control

@onready var health1 = $Health1
@onready var health2 = $Health2
@onready var health3 = $Health3

@onready var progress = $Progress

var noHealth = preload("res://Game_Files/Assets/UI/Minigames/Health_Missing.png")

var healthAmount = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func decreaseHealth():
	healthAmount = healthAmount - 1
	changeHealthUI()
	
func changeHealthUI():
	if (healthAmount == 2):
		health1.texture = noHealth
		
	if (healthAmount == 1):
		health2.texture = noHealth
		
	if (healthAmount == 0):
		health3.texture = noHealth
		get_tree().call_group("Minigame", "noHealth")
		
func updateProgress(val):
	progress.value = 120 - val
	
