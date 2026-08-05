extends Control
func _ready() -> void:
	
	$Master.value = GameState.master_volume 
	$Music.value = GameState.music_volume
	$Ambience.value = GameState.ambience_volume
	$SFX.value = GameState.sfx_volume
	
	change_bus_volume("Master", GameState.master_volume)
	change_bus_volume("Music", GameState.music_volume)
	change_bus_volume("SFX", GameState.sfx_volume)
	change_bus_volume("Ambience", GameState.ambience_volume)

func _on_exit_pressed() -> void:
	SFX.play(SFX.Labels.BUTTON_CLICK)
	
	var game: String = "uid://85alntk1uqvy"
	SceneSwitcher.switch_scene_no_player(game)

func _on_exit_mouse_entered():
	SFX.play(SFX.Labels.BUTTON_HOVER)


func _on_master_value_changed(value):
	change_bus_volume("Master", value)

func _on_music_value_changed(value):
	change_bus_volume("Music", value)

func _on_ambience_value_changed(value):
	change_bus_volume("Ambience", value)

func _on_sfx_value_changed(value):
	change_bus_volume("SFX", value)

func change_bus_volume(bus, linear_value):
	if bus == "Master":
		GameState.master_volume = linear_value
	if bus == "Music":
		GameState.music_volume = linear_value
	if bus == "SFX":
		GameState.sfx_volume = linear_value
	if bus == "Ambience":
		GameState.ambience_volume = linear_value
	
	var db_value = linear_to_db(linear_value)
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, db_value)
