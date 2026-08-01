extends Node2D

@export var center_pos: Vector2
@export var rail_dir: Vector2

@export var clear_type: GameState.RoomClearSignals
var cleared = false

func _ready():
	$Player.camera.get_node("Camera2D").zoom = Vector2(4,4)
	if rail_dir:
		$Player.camera.set_camera_rail(rail_dir, center_pos)
	else:
		$Player.camera.set_glide_position(center_pos, 100, true)

func _process(_delta):
	if cleared:
		return
	if clear_type == GameState.RoomClearSignals.PUZZLE:
		check_shot_orb_clear()
	if clear_type == GameState.RoomClearSignals.PUZZLE:
		check_enemies_clear()

func check_shot_orb_clear():
	for node in get_children():
		if node is TimedShotOrb:
			if not node.on:
				return
	cleared = true
	GameState.puzzle_cleared.emit()

func check_enemies_clear():
	pass
