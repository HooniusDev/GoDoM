#######################################
### shootray.gd 					###
###	Fires rays as bullets			###
#######################################

extends RayCast

# Cache original transform
var original_orientation

# Particle effect cache
# TODO: Move blood particles to enemy
var particle_small = preload("res://Scenes/Particles/BulletHitMetalSmall.tscn")
var particle_blood = preload("res://Scenes/Particles/BulletHitEnemySmall.tscn")
var particle_large = preload("res://Scenes/Particles/BloodParticles.tscn")

# Bullet tracer effect
# TODO: Move these in the weapon and reuse to minimize instancing
var tracer_scene = preload("res://Scenes/Misc/Tracer.tscn")

func _ready():
	original_orientation = transform.basis

func shoot( damage, spread ):
	# Rotate according to spread value randonmly
	var x = lerp(-spread,spread, randf())
	var y = lerp(-spread,spread, randf())

	rotate_x( deg2rad(x))
	rotate_y( deg2rad(y))

	# update ray from new orientation
	force_raycast_update()

	# we probably hit something always
	if is_colliding():

		# Variable cache
		var object = get_collider()
		var normal = get_collision_normal()
		var point = get_collision_point()
		var hit

		# if it was a damageable object
		# TODO: let object itself deal with particles and whatnots
		if object.has_method("take_damage"):
			object.take_damage(damage)

		# Ugly stuff to diffentiate enemy hit.
		# move this into object itself and do on take_damage()
		if object.is_in_group("enemy"):
			hit = particle_blood.instance()
		else:
			hit = particle_small.instance()
		get_tree().get_root().get_node("World").add_child(hit)

		hit.global_transform.origin = point

		var rotate_axis = Vector3(0,1,0)
		if normal == Vector3(0,1,0) or normal == Vector3(0,-1,0):
			rotate_axis = Vector3(1,0,0)
		hit.transform = hit.transform.looking_at( hit.transform.origin - normal, rotate_axis )
		hit.emitting = true
		# TODO: move to weapon
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



