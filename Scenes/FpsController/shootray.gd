extends RayCast

var original_orientation

var particle_small = preload("res://Scenes/Particles/BulletHitMetalSmall.tscn")
var particle_large = preload("res://Scenes/Particles/BulletHitMetalLarge.tscn")

var tracer_scene = preload("res://Scenes/Misc/Tracer.tscn")

func _ready():
	original_orientation = transform.basis

func shoot( damage, spread ):

	var x = lerp(-spread,spread, randf())
	var y = lerp(-spread,spread, randf())

	rotate_x( deg2rad(x))
	rotate_y( deg2rad(y))

	force_raycast_update()

	if is_colliding():
		var object = get_collider().get_parent()
		if object.has_method("take_damage"):
			object.take_damage(damage)
		var normal = get_collision_normal()
		var point = get_collision_point()
		var hit
		if damage > 3:
			hit = particle_large.instance()
		else:
			hit = particle_small.instance()
		get_tree().get_root().get_node("World").add_child(hit)

		hit.global_transform.origin = point

		var rotate_axis = Vector3(0,1,0)
		if normal == Vector3(0,1,0) or normal == Vector3(0,-1,0):
			rotate_axis = Vector3(1,0,0)
		hit.transform = hit.transform.looking_at( hit.transform.origin - normal, rotate_axis )
		hit.emitting = true

		create_tracer(point)

	transform = original_orientation

func create_tracer(end_point):
	var tracer = tracer_scene.instance()
	get_tree().get_root().get_node("World").add_child(tracer)
	# Start at players current weapon muzzle
	var tracer_start = Player.current_weapon.flash.global_transform.origin
	tracer.global_transform.origin = tracer_start
	tracer.global_transform = tracer.global_transform.looking_at( end_point, Vector3(0,1,0))
	var length = tracer_start - end_point
	tracer.scale.z = length.length()

	pass


