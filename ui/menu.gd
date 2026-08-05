extends Control

func _ready() -> void:
	$Fade.color.a = 0.0

func _on_start_pressed() -> void:
	SFX.play(SFX.Labels.BUTTON_CLICK)
	
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	var game: PackedScene = load("uid://bvhckihcs8a5l")
	# Use change_zone to also fix the camera to the map's bounds
	SceneSwitcher.switch_scene("res://world/desert_area/desert_A.tscn", "FromGrass")
	#SceneSwitcher.switch_scene(game)

func _on_settings_pressed() -> void:
	SFX.play(SFX.Labels.BUTTON_CLICK)
	
	var setting: String = "uid://cyyylb4r6n4c"
	SceneSwitcher.switch_scene_no_player(setting)

func _on_quit_pressed() -> void:
	SFX.play(SFX.Labels.BUTTON_CLICK)
	
	get_tree().quit()

func _on_start_mouse_entered():
	SFX.play(SFX.Labels.BUTTON_HOVER)

func _on_settings_mouse_entered():
	SFX.play(SFX.Labels.BUTTON_HOVER)
	
func _on_quit_mouse_entered():
	SFX.play(SFX.Labels.BUTTON_HOVER)
