###############################################
### PaueMenu.gd 							###
### 										###
###############################################

extends ViewportContainer

func _ready():
	set_process(false)

# Hides and disables menu
func on_continue_game():
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(false)

func show_menu():
	get_tree().paused = true
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process(true)


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		on_continue_game()


func _on_Continue_pressed():
	on_continue_game()

func _on_MainMenu_pressed():
	pass # replace with function body

func _on_LoadGame_pressed():
	pass # replace with function body

func _on_Settings_pressed():
	pass # replace with function body

func _on_Quit_pressed():
	get_tree().quit()

