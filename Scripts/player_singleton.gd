extends Node

var player_scene = preload("res://Scenes/FpsController/FpsController.tscn")

enum ITEM_TYPES { AMMO, HEALTH, SHELL, BACKPACK, MINIGUN, KEY_BLUE, KEY_YELLOW, KEY_RED, SHOTGUN }

enum states { PAUSED, NORMAL, EQUIPPING }
var state = states.NORMAL

var player

var health = 100
var health_max = 100

var has_shotgun = true
var has_minigun = true

var shotgun_ammo = 10
var minigun_ammo = 0

var current_weapon = null

func spawn(world, spawn, init_weapons):
	if init_weapons:
		player = player_scene.instance()
		current_weapon = null
	world.add_child(player)
	player.transform = spawn.transform
	if init_weapons:
		has_shotgun = false
		has_minigun = false
		shotgun_ammo = 0
		minigun_ammo = 0
		set_current_weapon(player.unarmed)



func _process(delta):
	if not state == EQUIPPING:
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
			print("equipping!")
			yield(current_weapon.anim, "animation_finished")
			state = states.NORMAL
			print("done!")
		current_weapon = weapon
		current_weapon.equip()


func collect_item(item):
	if item.type == AMMO:
		print("ammo receiced")
	elif item.type == HEALTH:
		print("health receiced")
	elif item.type == MINIGUN:
		print("MINIGUN AND AMMO("+str(item.amount)+")" )
		has_minigun = true
		minigun_ammo = item.amount
		set_current_weapon(player.minigun)
	elif item.type == SHOTGUN:
		print("SHOTGUN AND AMMO("+str(item.amount)+")" )
		shotgun_ammo = item.amount
		has_shotgun = true
		if current_weapon != player.minigun and current_weapon != player.shotgun:
			set_current_weapon(player.shotgun)
	return true