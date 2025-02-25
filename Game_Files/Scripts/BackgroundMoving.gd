extends Sprite2D

var SPEED = 100

func _process(delta):
	global_position.x += SPEED * delta;
	
	if(global_position.x > 2880):
		global_position.x = -960;
