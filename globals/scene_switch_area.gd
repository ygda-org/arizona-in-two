extends Area2D

## path or uid of scene to go to
@export var to_scene: String
## name of node for spawn location
@export var spawn_loc: String

func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("player"):
		SceneSwitcher.switch_scene(to_scene, spawn_loc)
