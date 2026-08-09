extends StaticBody2D
class_name TimedShotOrb

@export var time: float = 1.0
var on: bool = false

func _ready():
	$Time.wait_time = time

func damaged_sequence():
	on = true
	$Sprite2D.texture = load("res://assets/dungeon_objects/purple_orb.png")
	$Time.start()


func _on_time_timeout():
	on = false
	$Sprite2D.texture = load("res://assets/dungeon_objects/blue_orb.png")
