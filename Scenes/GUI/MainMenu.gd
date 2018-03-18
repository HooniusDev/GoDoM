### MainMenu.gd v.01	###

extends ViewportContainer

onready var choice_marker = $Viewport/MenuShotguns
var game_button_y = .4
var new_button_y = 0
var settings_button_y = -.4

func _play_press(action):
	var anim = choice_marker.get_node("ShotgunAnimationPlayer")
	anim.play("ShootGuns")
	$AudioStreamPlayer.play()
	yield(anim, "animation_finished")
	anim.play("idle-loop")
	if action == "new":
		get_tree().change_scene("res://Scenes/GUI/LoadScreen.tscn")

func _on_NewGame_pressed():
	_play_press("new")

func _on_LoadGame_pressed():
	_play_press("load")


func _on_Settings_pressed():
	_play_press("settings")


func _on_NewGame_focus_entered():
	print("_on_NewGame_focus_entered!")
	choice_marker.translation.y = game_button_y

func _on_LoadGame_focus_entered():
	print("_on_LoadGame_focus_entered!")
	choice_marker.translation.y = new_button_y

func _on_Settings_focus_entered():
	print("_on_Settings_focus_entered!")
	choice_marker.translation.y = settings_button_y
