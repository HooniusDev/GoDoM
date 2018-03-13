extends Spatial

# Internal node cache
onready var ejector = $Ejector
onready var anim = $AnimationPlayer
onready var shoot_sound = $ShootSound
onready var shoot_ray = $"../ShootRay"
onready var flash = $ArmatureMinigun/Muzzle

# Scene references
#var bullet = preload("res://Assets/Weapons/Bullets/MinigunBullet.tscn")

#var bullet_hit = preload("res://Scenes/Particles/minigun_impact.tscn")

enum STATES { NONE, EQUIP, IDLE, SPOOL_UP, SHOOT, SPOOL_DOWN, DE_EQUIP }
var state = STATES.NONE setget set_state

# Barrel
export (float) var barrel_full_rotation_speed = 2

# Shoot variables
export (float) var fire_rate = .05
var fire_timer = .05
var shoot_loop_start = 1.8
var shoot_loop_end = 5.6

var damage = 2

# Spool variables. Time it takes to minigun to start firing bullets
var spool = 0
export (float) var spooling_delay = 2

# Function to equip
func equip():
	set_state(EQUIP)

# Function to de_equip
func de_equip():
	disable()
	set_state(DE_EQUIP)

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

# Shoot state
func _process_shoot(delta):
#	fire_timer -= delta
#	if fire_timer < 0:
#		fire_timer = fire_rate
#		if shoot_sound.get_playback_position() > shoot_loop_end:
#			shoot_sound.seek(shoot_loop_start)
#		#create and send bullet case to world
#		var instance = bullet.instance()
#		get_tree().get_root().get_node("World").add_child(instance)
#		instance.global_transform = ejector.global_transform
#		instance.linear_velocity = instance.global_transform.basis.x * 7 + get_node("../../..").velocity
#		_create_impact()
	pass

# Called from AnimationPlayer
func on_shot_fired():
	if state != SPOOL_UP:
		print("shot fired")
#	shoot_ray.force_raycast_update()
#	if shoot_ray.is_colliding():
#		var object = shoot_ray.get_collider().get_parent()
#		if object.has_method("take_damage"):
#			object.take_damage(damage)
#		var normal = shoot_ray.get_collision_normal()
#		var point = shoot_ray.get_collision_point()
#		var hit = bullet_hit.instance()
#		get_tree().get_root().get_node("World").spawn_weapon_hit( point, normal, bullet_hit )




# Spool Dwon state
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

func disable():
	set_process(false)
	hide()

func enable():
	set_process(true)



func on_anim_finished( anim_name ):
	# De Equip anim done
	if anim_name == "equip" and state == DE_EQUIP:
		disable()
	if anim_name == "equip" and state == EQUIP:
		set_state(IDLE)
		enable()

func set_state(new_state):
	if state == new_state:
		return
	elif new_state == STATES.SPOOL_UP:
		print("pooling_up")
		anim.play("minigun_shoot")
		anim.playback_speed = 0
		shoot_sound.play()
	elif new_state == STATES.SHOOT:
		print("state: SHOOT")
		anim.play("minigun_shoot")
		anim.playback_speed = 1
		flash.show()
		shoot_sound.play(shoot_loop_start)
	elif new_state == STATES.SPOOL_DOWN:
		print("pooling_down")
		anim.play("minigun_shoot")
		flash.hide()
		shoot_sound.play(6)
	elif new_state == STATES.IDLE:
		print("idle")
		pass
	elif new_state == STATES.DE_EQUIP:
		if state == SHOOT:
			shoot_sound.play(6)
			flash.stop()
			flash.hide()
		print("DE_EQUIP")
		anim.playback_speed = 2
		anim.play_backwards("equip")
	elif new_state == STATES.EQUIP:
		show()
		spool = 0
		anim.playback_speed = 1
		anim.play("equip")
		#print("de_equip")
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
	#disable()
	equip()
	anim.connect("animation_finished",self, "on_anim_finished")




