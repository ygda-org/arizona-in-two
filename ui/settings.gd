extends Control
func _ready() -> void:
	visible = true
	
	$Master.value = GameState.master_volume 
	$Music.value = GameState.music_volume
	$Ambience.value = GameState.ambience_volume
	$SFX.value = GameState.sfx_volume
	
	change_bus_volume("Master", GameState.master_volume)
	change_bus_volume("Music", GameState.music_volume)
	change_bus_volume("SFX", GameState.sfx_volume)
	change_bus_volume("Ambience", GameState.ambience_volume)

#func _process(_delta):
	#if Input.is_action_just_pressed("Menu"):
		#toggle_pause()
	#if not visible:
		#return
	#SFX.pause_all()
	#SFX.unpause_type(SFX.Id.BUTTON_CLICK)
	#SFX.unpause_type(SFX.Id.BUTTON_HOVER)

func _on_exit_pressed() -> void:
	SFX.play(SFX.Id.BUTTON_CLICK)
	#toggle_pause()
	var game: String = "uid://85alntk1uqvy"
	SceneSwitcher.switch_scene_no_player(game)

func toggle_pause():
	if get_tree().paused == true:
		SFX.unpause_all(true, 10.0)
	if get_tree().paused == false:
		SFX.pause_all(true, 10.0)
		
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused

func _on_exit_mouse_entered():
	SFX.play(SFX.Id.BUTTON_HOVER)


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
