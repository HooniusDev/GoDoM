#######################################
### World.gd 						###
### Root Handler script				###
#######################################
extends Node

# Show PauseMenu
func on_pause_game():
	#get_tree().paused = true
	$HUD/PauseMenu.show_menu()
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# spawn player ( TODO: refactor to spawn start and spawn loaded )
	Player.spawn( self, $StartSpawn, true)
	AudioMaster.play_static_sound()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		on_pause_game()
	if Input.is_action_just_pressed("debug_restart_level"):
		get_tree().reload_current_scene()