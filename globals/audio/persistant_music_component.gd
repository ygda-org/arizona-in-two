extends Node

class_name PersistantNodeComponent

@export var music : MusicSettings.MUSIC_LABEL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if MusicManager.current_track != music and music not in MusicManager.queue:
		MusicManager.clear_all_audio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MusicManager.current_track != music and music not in MusicManager.queue:
		MusicManager.queue.append(music)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if MusicManager.current_track != music and music not in MusicManager.queue:
		MusicManager.clear_all_audio()
