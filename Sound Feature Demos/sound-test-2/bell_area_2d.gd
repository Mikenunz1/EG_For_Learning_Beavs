extends Area2D

@onready var bellAudioStream = $"AudioStreamPlayer2D-bell"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		bellAudioStream.play()
