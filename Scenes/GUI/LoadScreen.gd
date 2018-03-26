###############################################
### LoadScreen.gd 							###
### handles bullet casing sounds			###
###############################################
extends ViewportContainer

# Hard coded to load the demo-scene
var loaded_scene = "res://Scenes/HooBase1.tscn"

func _input(event):
	# Wait for any key..
	if event is InputEventMouseButton or event is InputEventKey:
		get_tree().change_scene_to(preload("res://Scenes/HooBase1.tscn"))
