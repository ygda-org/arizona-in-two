extends AnimatedSprite2D

@export var type : String

# Called when the node enters the scene tree for the first time.
func set_type():
	if type == null:
		push_error("No type set for an EnemyDeadBody")
		return
	play(type)
