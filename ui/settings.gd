extends Control

func _ready() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	SFXManager.create_audio(SFXSettings.SFX_LABEL.ButtonPress)
	
	var game: String = "uid://85alntk1uqvy"
	SceneSwitcher.switch_scene_no_player(game)
