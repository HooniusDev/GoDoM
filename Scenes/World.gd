extends Node

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Player.on_respawn()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#get_tree().quit()
	if Input.is_action_just_pressed("restart_game"):
		Player.on_respawn()
		get_tree().reload_current_scene()