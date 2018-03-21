#######################################
### audio_master.gd 				###
### Autoloaded manager for audio 	###
#######################################
extends Node

#var bullet_case_cling = preload("res://Assets/Sounds/BulletCaseCling.tscn")
var static_hum

# Creates a sound effect at a certain position
func play_sound_at( effect, position ):
	effect = effect.instance()
	add_child(effect)
	effect.transform.origin = position
	effect.play()
	# Free effect when sound clip is finished
	effect.connect("finished", self, "on_Effect_finished", [effect])

func play_static_sound():
	static_hum = AudioStreamPlayer.new()
	add_child(static_hum)
	static_hum.stream = preload("res://Assets/Sounds/Static/mystic-alien-soundscape-c.wav")
	static_hum.play()
	static_hum.volume_db = -20

func on_Effect_finished(effect):
	effect.queue_free()

func _notification(what):
	if what == NOTIFICATION_PAUSED:
		static_hum.stop()
	if what == NOTIFICATION_UNPAUSED:
		static_hum.play()


