extends Control

func setGameResolution (val):
	match val:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func setTextSize (val):
	match val:
		0: 
			pass
		1:
			pass
		2:
			pass	
		
