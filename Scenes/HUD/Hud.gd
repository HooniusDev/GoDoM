###############################################
### Hud.gd 							###
### HUD manager			###
###############################################
extends CanvasLayer


func _ready():
	#Connect to player stat changes signal
	Player.connect("player_stats_changed",self,"_on_player_stats_changed")

	#Handler for stat changed signal
func _on_player_stats_changed():
	$Info/HealthLabel.text = "Health " + str(Player.health)
	$Info/AmmoLabel.text =  str(Player.current_weapon.ammo) + " Ammo"

