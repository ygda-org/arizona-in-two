@tool
extends ColorRect

@export var disable: bool = false:
	set(new_bool):
		disable = new_bool
		material.set_shader_parameter("disable", new_bool)

func _ready():
	set_travel_direction()

func set_travel_direction():
	if Engine.is_editor_hint():
		return
	var tween = get_tree().create_tween()
	var x = randf_range(-80,80)
	tween.tween_property(self, "position", Vector2(position.x + x, position.y + x), abs(x)/40)
	tween.tween_callback(set_travel_direction)
