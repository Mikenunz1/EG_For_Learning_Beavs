extends Control

func setGameResolution (val):
	
	val = int(val)
	
	match val:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			print("It should be this one")
			
	get_tree().call_group("GameManager", "updateResolution", val)


func setTextSize (val):
	
	val = int(val)
	
	match val:
		0: 
			pass
		1:
			pass
		2:
			pass	
	
	get_tree().call_group("GameManager", "updateTextSize", val)
		
