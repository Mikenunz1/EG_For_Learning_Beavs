extends Button

@export var stream: AudioStream

func _on_pressed():
	GlobalAudioManager.play_sound(stream)
