################################################
### collectable.gd 							 ###
### controller for items that are collectable###
################################################
extends Area

const TYPE = preload("res://Scripts/player_singleton.gd").ITEM_TYPES

export (TYPE) var type
export (int) var amount = 100

func _ready():
	add_to_group("collectable")
	connect("body_entered", self, "_on_Area_body_entered")

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if Player.collect_item(self):
			queue_free()
