# fps_controller.gd
# Based from Jeremy Bullock's Youtube tutorial
# https://www.youtube.com/playlist?list=PLTZoMpB5Z4aD-rCpluXsQjkGYgUGUZNIV

extends KinematicBody

onready var head = $Head
onready var camera = $Head/Camera
onready var minigun = $Head/Camera/Minigun
onready var shotgun = $Head/Camera/Shotgun
onready var unarmed = $Head/Camera/Unarmed

#camera variables
var camera_angle = 0
var mouse_sensitivity = 0.3
var camera_change = Vector2()

#movement variables
var velocity = Vector3()
var direction = Vector3()

#fly variables
const FLY_SPEED = 40
const FLY_ACCEL = 4

#walk variables
var gravity = -9.8 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 30
const ACCEL = 2
const DEACCEL = 6

#jump variables
var jump_height = 10
var has_contact = false

# slope
const MAX_SLOPE_ANGLE = 45

func _ready():
	Player.player = self
	set_name("Player")

func _physics_process(delta):
	aim()
	walk(delta)

func walk(delta):
	# reset direction of player
	direction = Vector3()

	var aim = camera.global_transform.basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_back"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x

	direction.y = 0

	direction = direction.normalized();

	if (is_on_floor()):
		has_contact = true
		var n = $CollisionShape/Tail.get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3(0,1,0))))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
	else:
		if !$CollisionShape/Tail.is_colliding():
			has_contact = false
		velocity.y += gravity * delta

	if (has_contact and !is_on_floor()):
		move_and_collide(Vector3(0,-1,0))

	var temp_velocity = velocity
	temp_velocity.y = 0

	var speed = MAX_SPEED
	if Input.is_action_just_pressed("sprint"):
		speed = MAX_RUNNING_SPEED

	# where would player go with max speed
	var target = direction * speed

	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL

	# calculate distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)

	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z

	# jump
	if has_contact and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
		has_contact = false

	# move
	velocity = move_and_slide(velocity, Vector3(0,1,0))

func fly(delta):
		# reset direction of player
	direction = Vector3()

	var aim = $Head/Camera.global_transform.basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_back"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x

	direction = direction.normalized();

	# where would player go with max speed
	var target = direction * FLY_SPEED

	# calculate distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)

	# move
	move_and_slide(velocity)

func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative

func aim():
	if camera_change.length() > 0:
		$Head.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))

		var change = -camera_change.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()





