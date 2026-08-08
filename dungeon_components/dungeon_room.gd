extends Node2D

@export var override_camera: bool = true

@export var clear_type: GameState.RoomClearSignals
var cleared = false

func _ready():
	var bg: ColorRect = ColorRect.new()
	bg.color = Color(32.0/256.0, 40.0/256.0, 78.0/256.0, 1.0) # 20284e
	bg.size = Vector2(10000,10000)
	bg.position = -bg.size/2
	bg.z_index = -100
	add_child(bg)
	$Player.camera.get_node("Camera2D").zoom = Vector2(4,4)
	$Player.camera.get_node("Camera2D").enabled = not override_camera
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	var gui = load("uid://bh2vqcphc387j").instantiate()
	canvas_layer.add_child(gui)
	gui.fade_in()

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
