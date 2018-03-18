extends ViewportContainer

var loaded_scene = "res://Scenes/HooBase1.tscn"

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		get_tree().change_scene_to(preload("res://Scenes/HooBase1.tscn"))
