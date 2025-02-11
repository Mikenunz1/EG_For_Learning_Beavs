extends Control

@onready var bgButtonSprite = $bgButtonSprite
@onready var sfxButtonSprite = $sfxButtonSprite

@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

@onready var menuAudioStream = $"AudioStreamPlayer-menu"

@onready var mute = load("res://menu-sfx.mp3")
@onready var unmute = load("res://menu-sfx3.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgButtonSprite.play("unmuted")
	sfxButtonSprite.play("unmuted")

func _on_bg_button_pressed() -> void:
	if bgButtonSprite.animation == "muted":
		bgButtonSprite.play("unmuted")
		AudioServer.set_bus_mute(MUSIC_BUS_ID, false)
		menuAudioStream.stream = (unmute)
		menuAudioStream.play()
	else:
		menuAudioStream.stream = (mute)
		menuAudioStream.play()
		bgButtonSprite.play("muted")
		AudioServer.set_bus_mute(MUSIC_BUS_ID, true)

func _on_sfx_button_pressed() -> void:
	if sfxButtonSprite.animation == "muted":
		sfxButtonSprite.play("unmuted")
		AudioServer.set_bus_mute(SFX_BUS_ID, false)
		menuAudioStream.stream = (unmute)
		menuAudioStream.play()
	else:
		menuAudioStream.stream = (mute)
		menuAudioStream.play()
		sfxButtonSprite.play("muted")
		#this is a temporary solution
		#it has strange behavior if the user spams the mute buttonaaa
		await get_tree().create_timer(0.2).timeout
		AudioServer.set_bus_mute(SFX_BUS_ID, true)
