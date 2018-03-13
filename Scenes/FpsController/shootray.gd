extends RayCast

var original_orientation

var particle = preload("res://Scenes/Particles/BaseParticle.tscn")

func _ready():
	original_orientation = transform.basis

func shoot( damage, spread ):
	print("shooting ray")

	var x = lerp(-spread,spread, randf())
	var y = lerp(-spread,spread, randf())

	print ( "rotation: " + str(x) + ", " + str(y) )

	rotate_x( deg2rad(x))
	rotate_y( deg2rad(y))

	force_raycast_update()

	if is_colliding():
		print("collided")
		var object = get_collider().get_parent()
		if object.has_method("take_damage"):
			object.take_damage(damage)
		var normal = get_collision_normal()
		var point = get_collision_point()

		var hit = particle.instance()
		get_tree().get_root().get_node("World").add_child(hit)

		hit.global_transform.origin = point

		var rotate_axis = Vector3(0,1,0)
		if normal == Vector3(0,1,0) or normal == Vector3(0,-1,0):
			rotate_axis = Vector3(1,0,0)
		hit.transform = hit.transform.looking_at( hit.transform.origin - normal, rotate_axis )
		hit.emitting = true

	transform = original_orientation

