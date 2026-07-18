extends Node2D

@export var center_pos: Vector2
@export var rail_dir: Vector2

func _ready():
	$Player.camera.get_node("Camera2D").zoom = Vector2(4,4)
	if rail_dir:
		$Player.camera.set_camera_rail(rail_dir, center_pos)
	else:
		$Player.camera.set_glide_position(center_pos, 10, true)
