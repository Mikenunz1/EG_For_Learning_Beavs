extends Node

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	#instance.pitch_scale = randi_range(1,20)
	add_child(instance)
	instance.play()

func remove_node(awef: AudioStreamPlayer):
	awef.queue_free()
	
