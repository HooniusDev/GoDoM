extends Spatial

### Cache ###
onready var anim = $AnimationPlayer

### State Machine ###
enum STATES { NONE, EQUIP, IDLE, HIT, DE_EQUIP }
var state  setget set_state

var ammo = 0

func set_state(new_state):
	if state == new_state:
		print("Already in that state " + str(new_state) )
		return
	elif new_state == STATES.HIT:
		anim.playback_speed = 1
		anim.play("unarmed_punch")
		#shoot_sound.play()
		#fire()
	elif new_state == STATES.IDLE:
		set_process(true)
		anim.play("unarmed_idle-loop")
		pass
	elif new_state == STATES.DE_EQUIP:
		anim.playback_speed = 2
		anim.play_backwards("equip")
		pass
	elif new_state == STATES.EQUIP:
		show()
		anim.playback_speed = 1
		anim.play("equip")
		pass
	elif new_state == STATES.NONE:
		anim.stop()
		hide()
		set_process(false)
	state = new_state

func on_anim_finished( anim_name ):
	if anim_name == "unarmed_punch":
		print("shot finished")
		set_state(IDLE)
	if anim_name == "equip" and state == EQUIP:
		print("equipped and idling")
		set_state(IDLE)
	if anim_name == "equip" and state == DE_EQUIP:
		set_state(NONE)

func _process(delta):
	### Inputs ###
	if Input.is_action_just_pressed("fire0") and state == IDLE:
		set_state( HIT )

func _ready():
	set_state(NONE)
	anim.connect("animation_finished",self, "on_anim_finished")

# Function to equip
func equip():
	set_state(EQUIP)

# Function to de_equip
func de_equip():
	set_state(DE_EQUIP)