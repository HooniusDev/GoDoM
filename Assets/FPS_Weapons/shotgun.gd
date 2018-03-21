### shotgun.gd v.2 	###
### GoDoM 			###
extends Spatial

# Node Cache
onready var anim = $AnimationPlayer
onready var shoot_ray = $"../ShootRay"
onready var shoot_sound = $ShotSound
onready var reload_sound = $ReloadSound
onready var flash = $ArmatureShotgun/Skeleton/BoneAttachment/Muzzle

signal on_shoot

# Weapon variables
var damage = 5
var pellets = 4
var spread = 5

var ammo = 0

### State Machine ###
enum STATES { NONE, EQUIP, IDLE, SHOOT, RELOADING, DE_EQUIP }
var state setget set_state

func set_state(new_state):
	if state == new_state:
		print("Already in that state " + str(new_state) )
		return
	elif new_state == STATES.SHOOT:
		fire()
	elif new_state == STATES.IDLE:
		set_process(true)
		anim.play("shotgun_idle")
	elif new_state == STATES.DE_EQUIP:
		anim.playback_speed = 2
		anim.play_backwards("shotgun_equip")
	elif new_state == STATES.EQUIP:
		show()
		anim.playback_speed = 1
		anim.play("shotgun_equip")
		# State of not equipped, Dont process and hide away
	elif new_state == STATES.NONE:
		anim.stop()
		hide()
		set_process(false)

	state = new_state

# Function called from shoot animation to cancel reload part
# TODO make animation with no ammo, gun held open or something
func should_reload():
	if ammo <= 0:
		set_state(IDLE)

# Change state when animation finishes
func on_anim_finished( anim_name ):
	print(anim_name)
	if anim_name == "Shotgun_shoot":
		set_state(IDLE)
		#flash.hide()
	if anim_name == "shotgun_equip" and state == EQUIP:
		set_state(IDLE)
	if anim_name == "shotgun_equip" and state == DE_EQUIP:
		set_state(NONE)

func fire():
	if ammo > 0:
		#flash.show()
		anim.playback_speed = 1
		anim.play("Shotgun_shoot")
		shoot_sound.play()
		for i in range(pellets):
			shoot_ray.shoot( damage, spread )
		ammo -= 1
		emit_signal("on_shoot")
	else:
		# play denied sound!
		pass

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

