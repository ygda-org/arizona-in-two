extends Area2D

## 1 silver, 2 ice, 3 fire
@export var upgrade_level: int = 0

func _ready():
	if GameState.player_max_bullet_strength >= upgrade_level:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player") and GameState.player_max_bullet_strength <= upgrade_level:
		GameState.player_max_bullet_strength = upgrade_level
		queue_free()
