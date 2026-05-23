extends Node

var queue : Array[SFXSettings.SFX_LABEL] = []

@export var sound_effect_dict : Dictionary[SFXSettings.SFX_LABEL, SFXSettings]

var rng = RandomNumberGenerator.new()

var current_track : int = -1

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if get_child_count() == 0 and len(queue) > 0:
		current_track = queue.pop_front()
		create_audio(current_track)
	

func _on_audio_finished(source : AudioStreamPlayer):
	current_track = -1
	source.queue_free()

func create_audio(type : SFXSettings.SFX_LABEL):
	var audioplayer : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audioplayer)
	var sound_effect_setting = sound_effect_dict[type]
	audioplayer.stream = sound_effect_setting.stream
	audioplayer.volume_linear = sound_effect_setting.volume
	audioplayer.pitch_scale = sound_effect_setting.pitch
	audioplayer.finished.connect(audioplayer.queue_free)
	audioplayer.name = str(sound_effect_setting.label)
	audioplayer.finished.connect(_on_audio_finished.bind(audioplayer))
	audioplayer.play(sound_effect_setting.audio_start_offset)
	#GlobalLog.log("Playing: " + str(sound_effect_setting.label))

func create_audio_with_variance(type : SFXSettings.SFX_LABEL, pitch_range : Vector2):
	var audioplayer : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audioplayer)
	var sound_effect_setting = sound_effect_dict[type]
	audioplayer.stream = sound_effect_setting.stream
	audioplayer.volume_linear = sound_effect_setting.volume
	audioplayer.pitch_scale = rng.randf_range(pitch_range.x,pitch_range.y)
	audioplayer.finished.connect(audioplayer.queue_free)
	audioplayer.name = str(sound_effect_setting.label)
	audioplayer.finished.connect(_on_audio_finished.bind(audioplayer))
	audioplayer.play(sound_effect_setting.audio_start_offset)

func clear_all_audio():
	for child in get_children():
		child.queue_free()
	current_track = -1
