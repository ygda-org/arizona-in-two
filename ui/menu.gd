extends Control

func _ready() -> void:
	$Fade.color.a = 0.0

func _on_start_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	var game: PackedScene = load("uid://bvhckihcs8a5l")
	# Use change_zone to also fix the camera to the map's bounds
	ZoneManager.change_zone(game, ZoneManager.ZONE_DIRECTION.NONE, Vector2(288,357))
	#SceneSwitcher.switch_scene(game)

func _on_settings_pressed() -> void:
	var setting: PackedScene = load("uid://cyyylb4r6n4c")
	SceneSwitcher.switch_scene(setting)

func _on_quit_pressed() -> void:
	get_tree().quit()
