extends Node2D

@export var override_camera: bool = true

@export var clear_type: GameState.RoomClearSignals
var cleared = false

func _ready():
	$Player.camera.get_node("Camera2D").zoom = Vector2(4,4)
	$Player.camera.get_node("Camera2D").enabled = not override_camera

func _process(_delta):
	if cleared:
		return
	if clear_type == GameState.RoomClearSignals.PUZZLE:
		check_shot_orb_clear()
	if clear_type == GameState.RoomClearSignals.ENEMIES:
		check_enemies_clear()

func check_shot_orb_clear():
	for node in get_children():
		if node is TimedShotOrb:
			if not node.on:
				return
	cleared = true
	GameState.puzzle_cleared.emit()

func check_enemies_clear():
	for node in get_children():
		if "Enemy" in node.name: # bad solution, fix later
			return
	cleared = true
	GameState.enemies_cleared.emit()
