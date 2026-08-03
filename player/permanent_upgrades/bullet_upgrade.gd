extends Area2D

@export var upgrade_level: int

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.player_max_bullet_strength >= upgrade_level:
		queue_free()

func _on_body_entered(_body):
	GameState.player_max_bullet_strength = upgrade_level
	queue_free()
