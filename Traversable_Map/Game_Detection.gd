extends Area2D



func _on_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://Mini_Game_Demos/Tree_Cutting/TreeCutting.tscn")	
