extends Node



func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Player.spawn( self, $StartSpawn, true)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#get_tree().quit()
	if Input.is_action_just_pressed("debug_restart_level"):
		#Player.spawn(self, $StartSpawn, false)
		get_tree().reload_current_scene()