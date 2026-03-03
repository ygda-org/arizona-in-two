extends Node2D

@export var area: Area2D
@export var collision: CollisionShape2D
#Assumes that the collision shape is a circle. Probably fine for now
#but could cause issues later
@export var radius: int

func player_entered(_body):
	get_parent()._on_player_interaction()

func _ready():
	collision.shape.radius = radius
	area.body_entered.connect(player_entered)
