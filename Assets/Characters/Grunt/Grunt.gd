###############################################
### Grunt.gd 								###
### handles grunt behaviour					###
###############################################
extends KinematicBody

enum STATES { NONE, IDLE, PATROL, ATTACK }
var state  setget set_state

var navigation

var gravity = -9.8 * 3
var velocity = Vector3()

const SPEED =6
const ACCEL = 2
const DEACCEL = 6

func _ready():
	navigation = get_node("/root/World/Level/Navigation")
	set_state(IDLE)

func set_state(new_state):
	if state == new_state:
		return
	if new_state == IDLE:
		print("idle!")
		$AnimationPlayer.playback_speed = 1
		$AnimationPlayer.play("idle-loop")
	if new_state == ATTACK:
		print("attack!")
		$AnimationPlayer.playback_speed = 2
		$AnimationPlayer.play("Walk_cycle-loop")
	state = new_state

func _physics_process(delta):
	if state == IDLE:
		var length = (global_transform.origin - Player.player.global_transform.origin).length()
		var to_player = global_transform.origin - Player.player.global_transform.origin
		if length < 10 and transform.basis.z.dot(to_player.normalized()) > .4 :
			set_state(ATTACK)
	if state == ATTACK:
		turn(delta)
		var path = navigation.get_simple_path(transform.origin, Player.player.global_transform.origin)
		if path.size()>0:
			velocity.y += gravity * delta
			var dir = (path[1] - transform.origin).normalized()
			move_and_slide( dir * 2, Vector3(0,1,0))

func turn(delta):
	var player_pos = Player.player.transform.origin
	transform = transform.looking_at( Vector3(player_pos.x, transform.origin.y, player_pos.z), Vector3(0,1,0))

func _process(delta):
	if Input.is_action_just_pressed("go_grunt"):
		set_state(ATTACK)
	if Input.is_action_just_pressed("patrol_grunt"):
		set_state(IDLE)
