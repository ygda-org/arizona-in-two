extends Area2D

@export var key_id: String

func _ready():
	if key_id in GameState.persist_keys_obtained:
		queue_free()

func _on_body_entered(_body):
	GameState.player_keys += 1
	GameState.persist_keys_obtained.append(key_id)
	queue_free()
