extends Control

var button_grow_time : float = 0.05
var button_grow_amount : float = 0.15

func _ready() -> void:
	visible = false
	
	create_bitmap($ResumeButton)
	
	$GridContainer/Master.value = GameState.master_volume 
	$GridContainer/Music.value = GameState.music_volume
	$GridContainer/Ambience.value = GameState.ambience_volume
	$GridContainer/SFX.value = GameState.sfx_volume
	
	change_bus_volume("Master", GameState.master_volume)
	change_bus_volume("Music", GameState.music_volume)
	change_bus_volume("SFX", GameState.sfx_volume)
	change_bus_volume("Ambience", GameState.ambience_volume)

func create_bitmap(button):
	if button.texture_normal:
		# Get the image from the texture normal
		var image = button.texture_normal.get_image()
		# Create the BitMap
		var bitmap = BitMap.new()
		# Fill it from the image alpha
		bitmap.create_from_image_alpha(image)
		# Assign it to the mask
		button.texture_click_mask = bitmap

func _process(_delta):
	if Input.is_action_just_pressed("Menu"):
		GameState.from_menu = false
		toggle_pause()
		
	if GameState.from_menu and get_tree().paused == false:
		toggle_pause()

func toggle_pause():
	if get_tree().paused == true:
		SFX.unpause_all(true, 10.0)
	if get_tree().paused == false:
		SFX.pause_all(true, 10.0)
		
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused

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


func _on_resume_button_mouse_entered():
	var tween : Tween = $ResumeButton.create_tween()
	tween.tween_property($ResumeButton, "scale", Vector2(3 + button_grow_amount,3 + button_grow_amount), 0.05)
	SFX.play(SFX.Id.BUTTON_HOVER)


func _on_resume_button_pressed():
	var tween : Tween = $ResumeButton.create_tween()
	tween.tween_property($ResumeButton, "scale", Vector2(3 - button_grow_amount,3 - button_grow_amount), 0.025)
	tween.tween_interval(0.1)
	tween.tween_property($ResumeButton, "scale", Vector2(3,3), 0.025)
	SFX.play(SFX.Id.BUTTON_CLICK)
	await get_tree().create_timer(0.25).timeout
	visible = false


func _on_resume_button_mouse_exited():
	var tween : Tween = $ResumeButton.create_tween()
	tween.tween_property($ResumeButton, "scale", Vector2(3,3), button_grow_amount)
