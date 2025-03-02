extends Node2D

#Fuction that all scenes have that remove them from tree
func removeSelf():
	queue_free()
