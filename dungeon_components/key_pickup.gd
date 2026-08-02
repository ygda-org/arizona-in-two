extends Area2D

@export var key_id: String
@export var spawn_signal: GameState.RoomClearSignals

@export var is_big_key: bool = false

func _ready():
	if spawn_signal != 0:
		monitoring = false
		visible = false
		GameState.room_clear_signal_array[spawn_signal].connect(spawn)
	if key_id in GameState.persist_keys_obtained:
		queue_free()

func spawn():
	monitoring = true
	visible = true

func _on_body_entered(_body):
	if is_big_key:
		GameState.player_big_keys += 1
	else:
		GameState.player_keys += 1
	GameState.persist_keys_obtained.append(key_id)
	queue_free()
