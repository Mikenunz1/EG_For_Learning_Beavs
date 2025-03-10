extends Node2D

@onready var NPCtext = $InteractText

@export var NPCDialogue = ["Welcome to the forest", "It's nice to meet you!", "I'm a beaver"]

var interactPossible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("Interact") && interactPossible):
		loadInteraction()

func interact_area_entered(area):
	if (area.is_in_group("Player")):
		NPCtext.show()
		interactPossible = true


func interact_area_exited(area):
	if (area.is_in_group("Player")):
		NPCtext.hide()
		interactPossible = false

func loadInteraction():
	get_tree().call_group("Interaction", "startInteraction", NPCDialogue, len(NPCDialogue) - 1)
