extends Node2D

@onready var musicAudioStreamBG = $"AudioStreamPlayer-BGMusic"
var backgroundMusicOn = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_music_status()
	
func update_music_status():
	if backgroundMusicOn:
		if !musicAudioStreamBG.playing:
			musicAudioStreamBG.play()
	else: 
		musicAudioStreamBG.stop()
