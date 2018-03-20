#######################################
### audio_master.gd 				###
### Autoloaded manager for audio 	###
#######################################
extends Node

#var bullet_case_cling = preload("res://Assets/Sounds/BulletCaseCling.tscn")

# Creates a sound effect at a certain position
func play_sound_at( effect, position ):
	effect = effect.instance()
	add_child(effect)
	effect.transform.origin = position
	effect.play()
	# Free effect when sound clip is finished
	effect.connect("finished", self, "on_Effect_finished", [effect])
	pass

func on_Effect_finished(effect):
	effect.queue_free()
