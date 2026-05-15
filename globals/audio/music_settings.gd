extends Resource

class_name MusicSettings

enum MUSIC_LABEL{
	AZBoss2,
	DesertTheme,
	FireTheme,
	IceTheme,
	Pause,
	MainMenu,
}

@export var label : MUSIC_LABEL
@export var stream : AudioStream
@export_range(-40,24) var volume : float = 1.0
@export_range(0.01, 4.0) var pitch : float = 1.0
@export var audio_start_offset : float = 0.0
