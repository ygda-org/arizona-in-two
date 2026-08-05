extends Control

func _ready() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	SFX.play(SFX.Labels.BUTTON_CLICK)
	
	var game: String = "uid://85alntk1uqvy"
	SceneSwitcher.switch_scene_no_player(game)

func _on_exit_mouse_entered():
	SFX.play(SFX.Labels.BUTTON_HOVER)
