###############################################
### BulletCase.gd 							###
### handles bullet casing sounds			###
###############################################
extends RigidBody

export (float) var life_time

var time = 0
var collided = false

export (AudioStream) var cling = preload("res://Assets/Sounds/BulletCaseCling.tscn")

func _process(delta):
	time += delta
	if time > life_time:
		queue_free()

func _on_BulletCase_body_entered(body):
	# Play cling and stop registering for collisions
	if not collided:
		collided = true
		AudioMaster.play_sound_at( cling, global_transform.origin )
		# Stop registering collisions #
		contacts_reported = 0
		disconnect("body_entered",self,"_on_BulletCase_body_entered")
