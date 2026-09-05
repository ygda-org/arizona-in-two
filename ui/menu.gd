extends Control

var button_grow_time : float = 0.05
var button_grow_amount : float = 0.05

func _ready() -> void:
	$Fade.color.a = 0.0
	$Bullet.visible = false
	$"2TextPivot/2TextLeft".visible = false
	$"2TextPivot/2TextRight".visible = false

func _on_play_button_pressed() -> void:
	GameState.from_menu = false
	$VBoxContainer/PlayButton.disabled = true
	$JackieAnimationPlayer.play("return_to_shoot")
	$ArizonaTextAnimationPlayer.play("return_to_shoot")
	await get_tree().create_timer(0.25).timeout
	#$JackieAnimationPlayer.play("shoot")
	SFX.play(SFX.Id.GUNSHOT, false, -6)
	SFX.play(SFX.Id.GUNSHOT_QUICK, false, -6)
	$Bullet.visible = true
	$ShootAnimationPlayer.play("shoot")
	$ExplosionParticles.emitting = true
	await get_tree().create_timer(0.047).timeout
	SFX.play(SFX.Id.WOOD_BREAK)
	$"2TextPivot/2Text".visible = false
	$"2TextPivot/2TextLeft".visible = true
	$"2TextPivot/2TextRight".visible = true
	await get_tree().create_timer(0.375).timeout
	$FadeOutAnimationPlayer.play("fade_out")
	await $FadeOutAnimationPlayer.animation_finished
	var _game: PackedScene = load("uid://bvhckihcs8a5l")
	# Use change_zone to also fix the camera to the map's bounds
	get_tree().paused = false
	SceneSwitcher.switch_scene("res://world/desert_area/desert_A.tscn", "FromGrass")
	#SceneSwitcher.switch_scene(_game)

func _on_settings_button_pressed() -> void:
	await %SettingsButton.on_button_pressed_finished
	
	GameState.from_menu = true
	$SettingsMenu.visible = true
	
func _on_quit_button_pressed() -> void:
	await %QuitButton.on_button_pressed_finished
	get_tree().quit()

#region idle
func _on_birds_1_timer_timeout() -> void:
	$Birds1Timer.wait_time = randf_range(10,30)
	$Birds1Timer.start()
	$Birds1AnimationPlayer.play("birds_1")

func _on_birds_2_timer_timeout() -> void:
	$Birds2Timer.wait_time = randf_range(30,40)
	$Birds2Timer.start()
	$Birds2AnimationPlayer.play("birds_2")

func _on_birds_3_timer_timeout() -> void:
	$Birds3Timer.wait_time = randf_range(20,40)
	$Birds3Timer.start()
	$Birds3AnimationPlayer.play("birds_3")
#endregion
