extends RigidBody

export (float) var life_time

var time = 0
var collided = false

func _process(delta):
	time += delta
	if time > life_time:
		queue_free()

func _on_RigidBody_body_entered(body):
	if not collided:
		collided = true
		$AudioStreamPlayer3D.play()
		contacts_reported = 0
		disconnect("body_entered",self,"_on_RigidBody_body_entered")

func _on_BulletCase_body_entered(body):
	if not collided:
		collided = true
		$AudioStreamPlayer3D.play()
		contacts_reported = 0
		disconnect("body_entered",self,"_on_RigidBody_body_entered")
