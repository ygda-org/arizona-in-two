extends Control

func _ready() -> void:
	$Fade.color.a = 0.0
	$Bullet.visible = false
	$Explosion.visible = false
	$"2TextPivot/2TextLeft".visible = false
	$"2TextPivot/2TextRight".visible = false
	
func _on_start_pressed() -> void:
	SFX.play(SFX.Id.BUTTON_CLICK)
	$JackieAnimationPlayer.play("return_to_shoot")
	$ArizonaTextAnimationPlayer.play("return_to_shoot")
	await get_tree().create_timer(0.25).timeout
	SFX.play(SFX.Id.GUNSHOT)
	$ShootAnimationPlayer.play("shoot")
	$Explosion.visible = true
	$Explosion.play("default")
	await get_tree().create_timer(0.125).timeout
	$Explosion.visible = false
	$"2TextPivot/2Text".visible = false
	$"2TextPivot/2TextLeft".visible = true
	$"2TextPivot/2TextRight".visible = true
	await get_tree().create_timer(0.125).timeout
	$FadeOutAnimationPlayer.play("fade_out")
	await $FadeOutAnimationPlayer.animation_finished
	var _game: PackedScene = load("uid://bvhckihcs8a5l")
	# Use change_zone to also fix the camera to the map's bounds
	SceneSwitcher.switch_scene("res://world/desert_area/desert_A.tscn", "FromGrass")
	#SceneSwitcher.switch_scene(game)

func _on_settings_pressed() -> void:
	SFX.play(SFX.Id.BUTTON_CLICK)
	
	var setting: String = "uid://cyyylb4r6n4c"
	SceneSwitcher.switch_scene_no_player(setting)

func _on_quit_pressed() -> void:
	SFX.play(SFX.Id.BUTTON_CLICK)
	
	get_tree().quit()

func _on_start_mouse_entered():
	SFX.play(SFX.Id.BUTTON_HOVER)

func _on_settings_mouse_entered():
	SFX.play(SFX.Id.BUTTON_HOVER)
	
func _on_quit_mouse_entered():
	SFX.play(SFX.Id.BUTTON_HOVER)

func _on_birds_1_timer_timeout():
	$Birds1Timer.wait_time = randf_range(10,30)
	$Birds1Timer.start()
	$Birds1AnimationPlayer.play("birds_1")

func _on_birds_2_timer_timeout():
	$Birds1Timer.wait_time = randf_range(10,30)
	$Birds2AnimationPlayer.play("birds_2")
