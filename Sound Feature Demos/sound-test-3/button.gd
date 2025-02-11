extends Button

@onready var bellAudioStream = $"AudioStreamPlayer2D - bell"


func _on_pressed() -> void:
	bellAudioStream.play()
