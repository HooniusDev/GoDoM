###############################################
### MainMenu.gd 							###
### 										###
###############################################

extends ViewportContainer

onready var choice_marker = $Viewport/MenuShotguns
# TODO: replace with proper offset increment
var game_button_y = .4
var new_button_y = 0
var settings_button_y = -.4
var quit_button_y = -.8

func _ready():
	$MenuContainer/VBoxContainer/NewGame.grab_focus()

func _play_press(action):
	var anim = choice_marker.get_node("ShotgunAnimationPlayer")
	anim.play("ShootGuns")
	$AudioStreamPlayer.play()
	yield(anim, "animation_finished")
	anim.play("idle-loop")
	if action == "new":
		get_tree().change_scene("res://Scenes/GUI/LoadScreen.tscn")
	if action == "quit":
		get_tree().quit()

func _on_NewGame_pressed():
	_play_press("new")

func _on_LoadGame_pressed():
	_play_press("load")

func _on_Settings_pressed():
	_play_press("settings")

func _on_Quit_pressed():
	_play_press("quit")

# TODO: Replace wit single focus entered signal with button id
func _on_NewGame_focus_entered():
	choice_marker.translation.y = game_button_y

func _on_LoadGame_focus_entered():
	choice_marker.translation.y = new_button_y

func _on_Settings_focus_entered():
	choice_marker.translation.y = settings_button_y

func _on_Quit_focus_entered():
	choice_marker.translation.y = quit_button_y


