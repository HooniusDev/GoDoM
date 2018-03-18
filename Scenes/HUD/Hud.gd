extends CanvasLayer


func _ready():
	Player.connect("player_stats_changed",self,"_on_player_stats_changed")

func _on_player_stats_changed():
	$Info/HealthLabel.text = "Health " + str(Player.health)
	$Info/AmmoLabel.text =  str(Player.current_weapon.ammo) + " Ammo"

