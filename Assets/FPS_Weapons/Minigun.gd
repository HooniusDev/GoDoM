###############################################
### Minigun.gd 								###
### 										###
###############################################

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
var state  setget set_state

# Signals
signal on_shoot

# Barrel rotation speed
export (float) var barrel_full_rotation_speed = 1

# Shoot variables
var shoot_loop_start = 1.8
var shoot_loop_end = 5.6

var damage = 2
var spread = 2

var ammo = 0

# Spool variables. Time it takes to minigun to start firing bullets
var spool = 0
export (float) var spooling_delay = 2

# Function to equip
func equip():
	set_state(EQUIP)

# Function to de_equip
func de_equip():
	set_state(DE_EQUIP)

# Shoot state process to see if should loop back
func _process_shoot(delta):
		if shoot_sound.get_playback_position() > shoot_loop_end:
			shoot_sound.seek(shoot_loop_start)

# Called from AnimationPlayer
func fire():
	# Spooling uses same animation so have to filter them
	if state != SPOOL_UP and state != SPOOL_DOWN and ammo > 0:
		shoot_ray.shoot(damage, spread)
		#create and send bullet case to world
		var instance = bullet.instance()
		get_tree().get_root().get_node("World").add_child(instance)
		instance.global_transform = ejector.global_transform
		instance.linear_velocity = instance.global_transform.basis.x * 7 + get_node("../../..").velocity
		#update ammo and signal hud via Player singleton
		ammo -= 1
		emit_signal("on_shoot")
	else:
		#play_sound click!
		#set_state()
		pass

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
		if ammo <= 0:
			set_state(SPOOL_DOWN)
			return
		anim.playback_speed = 4
		flash.show()
		shoot_sound.play(shoot_loop_start)
	elif new_state == STATES.SPOOL_DOWN:
		flash.hide()
		shoot_sound.play(6)
	elif new_state == STATES.IDLE:
		set_process(true)
	elif new_state == STATES.DE_EQUIP:
		if state == SHOOT or state == SPOOL_UP:
			shoot_sound.play(6)
			flash.hide()
		anim.playback_speed = 2
		# Hack to make it nicer when quickly changing weapons
		if state == EQUIP:
			anim.play_backwards("equip", .7 )
		else:
			anim.play_backwards("equip")
	elif new_state == STATES.EQUIP:
		show()
		spool = 0
		anim.playback_speed = 1
		anim.play("equip")
		shoot_sound.play(6.5)
	# Weapon is not currently selected by player so show and stop all
	elif new_state == STATES.NONE:
		anim.stop()
		hide()
		flash.hide()
		set_process(false)
	state = new_state
#
func _process(delta):
	# while equipping dont start shooting
	if state != EQUIP and state != DE_EQUIP:
		### Inputs ###
		if Input.is_action_pressed("fire0") and not state == SHOOT and ammo > 0:
			set_state(SPOOL_UP)
		if Input.is_action_just_released("fire0"):
			set_state(SPOOL_DOWN)
	### Process States ###
	if state == STATES.SPOOL_UP:
		_process_spool_up(delta)
	elif state == STATES.SPOOL_DOWN:
		_process_spool_down(delta)
	elif state == STATES.SHOOT:
		if ammo > 0:
			_process_shoot(delta)
		else:
			flash.hide()
			set_state(SPOOL_UP)

func _ready():
	set_state(NONE)
	anim.connect("animation_finished",self, "on_anim_finished")

func _notification(what):
	if what == NOTIFICATION_PAUSED:
		if state == STATES.SHOOT:
			shoot_sound.stop()




