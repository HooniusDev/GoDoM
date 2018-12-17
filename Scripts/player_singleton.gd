#######################################
### player_singleton.gd 			###
### Autoloaded manager for player 	###
#######################################
extends Node

var player_scene = preload("res://Scenes/FpsController/FpsController.tscn")

# Collectable items
enum ITEM_TYPES { AMMO, HEALTH, SHELL, BACKPACK, MINIGUN, KEY_BLUE, KEY_YELLOW, KEY_RED, SHOTGUN }

# States Variables
enum states { PAUSED, NORMAL, EQUIPPING }
var state = states.NORMAL

# Reference to player node
var player

# Stats Variables
var health = 100
var health_max = 100

var has_shotgun = true
var has_minigun = true

var current_weapon = null

# Signal to update HUD
signal player_stats_changed

# Spawn player, TODO: add spawn and loaded spawn
func spawn(world, spawn, init_weapons):
	if init_weapons:
		player = player_scene.instance()
		current_weapon = null
	world.add_child(player)
	player.transform = spawn.transform
	if init_weapons:
		has_shotgun = false
		has_minigun = false
		set_current_weapon(player.unarmed)
	#Update HUH
	emit_signal("player_stats_changed")
	#Connect signals to update HUD on shot
	player.minigun.connect("on_shoot", self, "update_hud")
	player.shotgun.connect("on_shoot", self, "update_hud")

func update_hud():
	emit_signal("player_stats_changed")

func _process(delta):
	if not state == states.EQUIPPING:
		if Input.is_action_just_pressed("equip_minigun"):
			if has_minigun:
				set_current_weapon(player.minigun)
		if Input.is_action_just_pressed("equip_shotgun"):
			if has_shotgun:
				set_current_weapon(player.shotgun)
		if Input.is_action_just_pressed("equip_unarmed"):
				set_current_weapon(player.unarmed)

func set_current_weapon( weapon ):
		if current_weapon == weapon:
			return
		if current_weapon != null:
			current_weapon.de_equip()
			state = states.EQUIPPING
			#print("equipping!")
			# Wait for the de-equip animation to finish
			yield(current_weapon.anim, "animation_finished")
			state = states.NORMAL
			#print("done!")
		current_weapon = weapon
		current_weapon.equip()
		emit_signal("player_stats_changed")


func collect_item(item):
	if item.type == ITEM_TYPES.AMMO:
		#print("ammo receiced")
		player.minigun.ammo += item.amount
	elif item.type == ITEM_TYPES.SHELL:
		#print("shells receiced")
		player.shotgun.ammo += item.amount
	elif item.type == ITEM_TYPES.HEALTH:
		#print("health receiced")
		player.health += item.amount
	elif item.type == ITEM_TYPES.MINIGUN:
		#print("MINIGUN AND AMMO("+str(item.amount)+")" )
		has_minigun = true
		player.minigun.ammo += item.amount
		set_current_weapon(player.minigun)
	elif item.type == ITEM_TYPES.SHOTGUN:
		#print("SHOTGUN AND AMMO("+str(item.amount)+")" )
		player.shotgun.ammo += item.amount
		has_shotgun = true
		# Auto switch weapon logic
		if current_weapon.ammo == 0 or current_weapon != player.minigun and current_weapon != player.shotgun:
			set_current_weapon(player.shotgun)
	emit_signal("player_stats_changed")

	return true