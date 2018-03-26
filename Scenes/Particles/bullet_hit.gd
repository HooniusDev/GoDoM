###############################################
### bullet_hit.gd 							###
### Autodetructor for bullet hit particles	###
###############################################
extends Particles

var timer = 1

func _ready():
	timer = lifetime

func _process(delta):
	timer -= delta
	if timer < 0:
		queue_free()


