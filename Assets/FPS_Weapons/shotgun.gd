### shotgun.gd v.2 	###
### GoDoM 			###
extends Spatial

# Node Cache
onready var anim = $AnimationPlayer
onready var shoot_ray = $"../ShootRay"
onready var shoot_sound = $ShotSound
onready var reload_sound = $ReloadSound
onready var flash = $ArmatureShotgun/Muzzle

# Weapon variables
var damage = 5
var pellets = 4
var spread = 5

### State Machine ###
enum STATES { NONE, EQUIP, IDLE, SHOOT, RELOADING, DE_EQUIP }
var state setget set_state

func set_state(new_state):
	if state == new_state:
		print("Already in that state " + str(new_state) )
		return
	elif new_state == STATES.SHOOT:
		anim.playback_speed = 1
		anim.play("shotgun_shoot")
		shoot_sound.play()
		fire()
	elif new_state == STATES.IDLE:
		set_process(true)
		anim.play("shotgun_idle")
		pass
	elif new_state == STATES.DE_EQUIP:
		anim.playback_speed = 2
		anim.play_backwards("shotgun_equip")
	elif new_state == STATES.EQUIP:
		show()
		anim.playback_speed = 1
		anim.play("shotgun_equip")
		print("equip")
	elif new_state == STATES.NONE:
		anim.stop()
		hide()
		set_process(false)
	state = new_state

func on_anim_finished( anim_name ):
	if anim_name == "shotgun_shoot":
		print("shot finished")
		set_state(IDLE)
	if anim_name == "shotgun_equip" and state == EQUIP:
		print("equipped and idling")
		set_state(IDLE)
	if anim_name == "shotgun_equip" and state == DE_EQUIP:
		set_state(NONE)

func fire():
	for i in range(pellets):
		shoot_ray.shoot( damage, spread )

# Function to equip
func equip():
	set_state(EQUIP)

# Function to de_equip
func de_equip():
	set_state(DE_EQUIP)


func _ready():
	set_state(NONE)
	anim.connect("animation_finished",self, "on_anim_finished")

func _process(delta):
	### Inputs ###
	if Input.is_action_just_pressed("fire0") and state == IDLE:
		set_state( SHOOT )

