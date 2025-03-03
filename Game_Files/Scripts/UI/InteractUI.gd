extends Control

@onready var nextButton = $NextText/NextButton
@onready var displayedText = $GameText

var portraitNumber = 0
var dialogueLength = 0
var dialogueCounter = 0
var dialogue = []

#use to assign the narration sound effect
@onready var dialogueAudioStreamPlayer = $"AudioStreamPlayer-DialogueSFX"
@onready var talk = load("res://Game_Files/Assets/Audio/Sounds/UI SFX/text-narration-sfx.mp3")

func startInteraction(newDialogue, newLength):
	dialogueLength = newLength
	dialogue = newDialogue
	displayedText.text = dialogue[dialogueCounter]
	nextButton.disabled = false
	show()

func endInteraction():
	nextButton.disabled = true
	hide()
	
func loadDialogue():
	dialogueAudioStreamPlayer.stream = talk
	dialogueAudioStreamPlayer.play()
	dialogueCounter = dialogueCounter + 1
	
	if (dialogueCounter > dialogueLength):
		dialogueCounter = 0
		endInteraction()
		
	else:
		displayedText.text = dialogue[dialogueCounter]
		
