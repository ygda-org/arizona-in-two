extends Area2D

@export var key_id: String
@export var spawn_signal: GameState.RoomClearSignals

func _ready():
	if spawn_signal != 0.0:
		visible = false
		GameState.room_clear_signal_array[spawn_signal].connect(spawn)
	if key_id in GameState.persist_keys_obtained:
		queue_free()

func spawn():
	visible = true

func _on_body_entered(_body):
	GameState.player_keys += 1
	GameState.persist_keys_obtained.append(key_id)
	queue_free()
