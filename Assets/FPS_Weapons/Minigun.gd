# FPS Minigun controller script for GoDoM v.2

extends Spatial

# Cached Nodes
onready var ejector = $Ejector
onready var anim = $AnimationPlayer
onready var shoot_sound = $ShootSound
onready var shoot_ray = $"../ShootRay"
onready var flash = $ArmatureMinigun/Muzzle

# Scene preloads
var bullet = preload("res://Scenes/Misc/BulletCaseMinigun.tscn")
#var bullet_hit = preload("res://Scenes/Particles/minigun_impact.tscn")

# State Machine
enum STATES { NONE, EQUIP, IDLE, SPOOL_UP, SHOOT, SPOOL_DOWN, DE_EQUIP }
var state = STATES.NONE setget set_state

# Barrel rotation speed
export (float) var barrel_full_rotation_speed = 1

# Shoot variables
var shoot_loop_start = 1.8
var shoot_loop_end = 5.6

var damage = 2
var spread = 2

# Spool variables. Time it takes to minigun to start firing bullets
var spool = 0
export (float) var spooling_delay = 1.8

# Function to equip
func equip():
	set_state(EQUIP)

# Function to de_equip
func de_equip():
	set_state(DE_EQUIP)

# Shoot state process to see loop sound back
func _process_shoot(delta):
		if shoot_sound.get_playback_position() > shoot_loop_end:
			shoot_sound.seek(shoot_loop_start)


# Called from AnimationPlayer
func on_shot_fired():
	if state != SPOOL_UP:
		shoot_ray.shoot(damage, spread)
		#create and send bullet case to world
		var instance = bullet.instance()
		get_tree().get_root().get_node("World").add_child(instance)
		instance.global_transform = ejector.global_transform
		instance.linear_velocity = instance.global_transform.basis.x * 7 + get_node("../../..").velocity


# Spool Up state
func _process_spool_up(delta):
	#increment spool
	spool += delta
	if spool>spooling_delay:
		spool = spooling_delay
		set_state(SHOOT)
		return
	# lerp animation speed according to spool value
	anim.playback_speed = lerp(0,barrel_full_rotation_speed, spool)

# Spool Down state
func _process_spool_down(delta):
	# Spool dont twice as fast as up
	spool -= delta * 2
	if spool < 0:
		spool = 0
		anim.stop()
		set_state(IDLE)
		return
	# lerp animation speed
	anim.playback_speed = lerp(0,barrel_full_rotation_speed, spool)


func on_anim_finished( anim_name ):
	# De Equip anim done
	if anim_name == "equip" and state == DE_EQUIP:
		set_state(NONE)
	if anim_name == "equip" and state == EQUIP:
		set_state(IDLE)
	if anim_name == "minigun_shoot":
		set_state(IDLE)

func set_state(new_state):
	if state == new_state:
		return
	elif new_state == STATES.SPOOL_UP:
		anim.play("minigun_shoot")
		# start pooling from rotation speed of 0
		anim.playback_speed = 0
		# start playing the shoot loop
		shoot_sound.play()
	elif new_state == STATES.SHOOT:
		#anim.play("minigun_shoot")
		anim.playback_speed = 4
		flash.show()
		shoot_sound.play(shoot_loop_start)
	elif new_state == STATES.SPOOL_DOWN:
		#anim.play("minigun_shoot")
		flash.hide()
		shoot_sound.play(6)
	elif new_state == STATES.IDLE:
		print("idle")
		set_process(true)
	elif new_state == STATES.DE_EQUIP:
		if state == SHOOT or state == SPOOL_UP:
			shoot_sound.play(6)
			#flash.stop()
			flash.hide()
		anim.playback_speed = 2
		if state == EQUIP:
			anim.play_backwards("equip", .7 )
		else:
			anim.play_backwards("equip")
	elif new_state == STATES.EQUIP:
		show()
		spool = 0
		anim.playback_speed = 1
		anim.play("equip")
	elif new_state == STATES.NONE:
		anim.stop()
		hide()
		set_process(false)
	state = new_state
#
func _process(delta):
	if state != EQUIP and state != DE_EQUIP:
		### Inputs ###
		if Input.is_action_pressed("fire0") and not state == SHOOT:
			set_state(SPOOL_UP)
		if Input.is_action_just_released("fire0"):
			set_state(SPOOL_DOWN)
	### Process States ###
	if state == STATES.SPOOL_UP:
		_process_spool_up(delta)
	elif state == STATES.SPOOL_DOWN:
		_process_spool_down(delta)
	elif state == STATES.SHOOT:
		_process_shoot(delta)

func _ready():
	set_state(NONE)
	anim.connect("animation_finished",self, "on_anim_finished")




