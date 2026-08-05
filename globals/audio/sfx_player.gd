extends Node
# This node (the scene) to be added as a global named SFX

## Optionally, append a comment (##) after each label to describe where it is used [br]
## List of all sounds. Add a new item here when you add a new sound.
enum Labels {
	BUTTON_HOVER, ## # A button being hovered over
	CYCLE_CYLINDER, ## 
	DOOR_CLOSE, ## A wooden door opening
	DOOR_OPEN, ## A wooden door closing
	EMPTY_SHOT, ## An empty shot firing
	FIRE_AMBIENT, ## Fire ambience in the magma area
	FLAME, ## The sound of a specific flame
	FREEZE, ## The sound of the player being frozen
	GRASS_STEP, ## The player walking on grass
	GUNSHOT, ## The sound of a gun firing a live round
	HIT_SOUND, ## The sound of the player getting hit 
	MAGMA_STEP, ## The player walking in the magma area
	SECRET_SOUND, ## The sound of the player getting a secrey
	SNOW_FOOTSTEPS, ##The sound of the player walking on snow
	SWING_1, ## One variation of the player swinging a sword
	SWING_2, ## One variation of the player swinging a sword
	THICK_RELOAD, ## The sound of the player reloading their gun. "Thick," whatever that means
	THIN_RELOAD, ## The sound of the player reloading their gun. "Thin," whatever that means
	BUTTON_CLICK,
}

## [code]TRUE[/code]: Print debug messages [br]
## [code]FALSE[/code]: Do not print debug messages
const DEBUG_MESSAGES: bool = false

## Variable to make each [AudioStreamPlayer]'s name unique. 
## Increased by one when a new [AudioStreamPlayer] is instantiated.
var counter : int = 0

## A dictionary storing labels from [code]SFX.Labels[/code] and the associated [code]sfx_settings.gd[/code]
@export var label_to_setting: Dictionary[Labels, SfxSettings]

## [b]Play a sound in a new [AudioStreamPlayer], as defined by [param label]. It should be called as[/b] [code]SFX.play(SFX.Labels.NAME)[/code]. [br]
##[br]
## [param label]: The sound you want to play, defined in SFX.Labels [br]
## [param loop]: Whether the sound should loop or not. [code]Default: FALSE[/code] [br]
## [param volume_mod]: Volume that is added after variation is calculated. [code]Default: 0.0[/code] [br]
## [param pitch_mod]: Pitch that is added after variation is calculated. [code]Default: 0.0[/code]
func play(label: Labels, loop : bool = false, volume_mod: float = 0.0, pitch_mod: float = 0.0):
	# Checks if a min_delay_timer is in the scene tree, and if so, return early
	if has_node(Labels.keys()[label] + "MinDelayTimer"):
		return
	
	## The instance of an AudioStreamPlayer
	var audio_stream_player = AudioStreamPlayer.new()
	
	## The instance of sfx_settings.gd
	var setting = label_to_setting[label]
	audio_stream_player.bus = setting.bus
	audio_stream_player.stream = setting.stream
	audio_stream_player.name = Labels.keys()[label] + str(counter)
	counter += 1
	audio_stream_player.volume_db = setting.volume + randf_range(-1,1) * setting.volume_variance + volume_mod
	audio_stream_player.pitch_scale = setting.pitch + randf_range(-1,1) * setting.pitch_variance + pitch_mod
	if loop == true:
		audio_stream_player.stream.loop = true
	
	add_child(audio_stream_player)
	audio_stream_player.finished.connect(audio_stream_player.queue_free)
	audio_stream_player.playing = true
	
	if DEBUG_MESSAGES:
		print("Played one sound: ", audio_stream_player)
		
	if setting.min_delay != 0:
		_add_min_delay_timer(label)
		
	return audio_stream_player

#region unpause, pause, clear, play_2d
## [b]Unpause one [AudioStreamPlayer], with an optional fade in[/b] [br]
## [br]
## [param audio_stream_player]: The [AudioStreamPlayer] to be unpaused [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade in for. [code][code]Default: 1.0[/code][/code]
func unpause_one(audio_stream_player: AudioStreamPlayer, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node == audio_stream_player:
			if fade == true:
				_add_fade_timer(node, "unpause", fade_length)
			else:
				node.play()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Labels.keys()[_node_to_label(audio_stream_player)] +  "MinDelayTimer":
			node.set_paused(false)
			
	if DEBUG_MESSAGES:
		print("Unpaused one sound: ", audio_stream_player)

## [b]Unpause all [AudioStreamPlayer]s of a specific label, with an optional fade in[/b] [br]
## [br]
## [param label]: [AudioStreamPlayer]s that use this label will be unpaused [br]
## [param fade]: Whether the audio should fade in. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade in for. [code]Default: 1.0[/code]
func unpause_type(label: Labels, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if Labels.keys()[label] not in node.name:
				continue
			if fade == true:
				_add_fade_timer(node, "unpause", fade_length)
			else:
				node.play()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Labels.keys()[label] +  "MinDelayTimer":
			node.set_paused(false)
			
	if DEBUG_MESSAGES:
		print("Unpaused all sounds of type: ", Labels.keys()[label])

## [b]Unpause all [AudioStreamPlayer]s, with an optional fade in[/b] [br]
## [br]
## [param fade]: Whether the audio should fade in. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade in for. [code]Default: 1.0[/code]
func unpause_all(fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if fade == true:
				_add_fade_timer(node, "unpause", fade_length)
			else:
				node.play()
		# If the node is a MinDelayTimer, unpause it
		if node.name.contains("MinDelayTimer"):
			node.set_paused(false)
			
	if DEBUG_MESSAGES:
		print("Unpaused all sounds")

## [b]Pause one [AudioStreamPlayer], with an optional fade out.[/b] [br]
## [br]
## [param audio_stream_player]: The [AudioStreamPlayer] to be paused [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func pause_one(audio_stream_player : AudioStreamPlayer, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node == audio_stream_player:
			if fade == true:
				_add_fade_timer(node, "pause", fade_length)
			else:
				node.stop()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Labels.keys()[_node_to_label(audio_stream_player)] +  "MinDelayTimer":
			node.set_paused(true)
			
	if DEBUG_MESSAGES:
		print("Paused one sound: ", audio_stream_player)

## [b]Pause all [AudioStreamPlayer]s of a specific label, with an optional fade in[/b] [br]
## [br]
## [param label]: [AudioStreamPlayer]s that use this label will be paused [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func pause_type(label: Labels, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if Labels.keys()[label] not in node.name:
				continue
			if fade == true:
				_add_fade_timer(node, "pause", fade_length)
			else:
				node.stop()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Labels.keys()[label] +  "MinDelayTimer":
			node.set_paused(true)
			
	if DEBUG_MESSAGES:
		print("Paused all sounds of type: ", Labels.keys()[label])

## [b]Pause all [AudioStreamPlayer]s, with an optional fade out[/b] [br]
## [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func pause_all(fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if fade == true:
				_add_fade_timer(node, "pause", fade_length)
			else:
				node.stop()
		# If the node is a MinDelayTimer, unpause it
		if node.name.contains("MinDelayTimer"):
			node.set_paused(true)
			
	if DEBUG_MESSAGES:
		print("Paused all sounds")

## [b]Clear one [AudioStreamPlayer], with an optional fade out.[/b] [br]
## [br]
## [param audio_stream_player]: The [AudioStreamPlayer] to be paused [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func clear_one(audio_stream_player : AudioStreamPlayer, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node == audio_stream_player:
			if fade == true:
				_add_fade_timer(node, "clear", fade_length)
			else:
				node.queue_free()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Labels.keys()[_node_to_label(audio_stream_player)] +  "MinDelayTimer":
			node.queue_free()
			
	if DEBUG_MESSAGES:
		print("cleared one sound: ", audio_stream_player)

## [b]Clear all [AudioStreamPlayer]s of a specific label, with an optional fade out[/b] [br]
## [br]
## [param label]: [AudioStreamPlayer]s that use this label will be cleared [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func clear_type(label : Labels, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if Labels.keys()[label] not in node.name:
				continue
			if fade == true:
				_add_fade_timer(node, "clear", fade_length)
			else:
				node.queue_free()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Labels.keys()[label] +  "MinDelayTimer":
			node.queue_free()
			
	if DEBUG_MESSAGES:
		print("Cleared all sounds of type: ", Labels.keys()[label])

## [b]Clear all [AudioStreamPlayer]s, with an optional fade out[/b] [br]
## [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func clear_all(fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if fade == true:
				_add_fade_timer(node, "clear", fade_length)
			else:
				node.queue_free()
		# If the node is a MinDelayTimer, unpause it
		if node.name.contains("MinDelayTimer"):
			node.queue_free()
			
	if DEBUG_MESSAGES:
		print("Cleared all sounds")

## [b]Attach an AudioStreamPlayer2D of type label as a child of a node[/b] [br]
## [br]
## [param label]: The label that the [AudioStreamPlayer2D] should use [br]
## [param node]: The node that the [AudioStreamPlayer2D] should be attached on
func play_2d(label : Labels, node : Node):
	var setting = label_to_setting[label]
	var audio_stream_player_2d : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	AudioStreamPlayer2D.stream = setting.stream
	AudioStreamPlayer2D.volume_db = setting.volume
	AudioStreamPlayer2D.pitch_scale = setting.pitch
	AudioStreamPlayer2D.bus = setting.bus
	node.add_child(audio_stream_player_2d)

## [b]Attach an AudioStreamPlayer3D of type label as a child of a node[/b] [br]
## [br]
## [param label]: The label that the [AudioStreamPlayer3D] should use [br]
## [param node]: The node that the [AudioStreamPlayer3D] should be attached on
func play_3d(label : Labels, node : Node):
	var setting = label_to_setting[label]
	var audio_stream_player_3d : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	AudioStreamPlayer3D.stream = setting.stream
	AudioStreamPlayer3D.volume_db = setting.volume
	AudioStreamPlayer3D.pitch_scale = setting.pitch
	AudioStreamPlayer3D.bus = setting.bus
	node.add_child(audio_stream_player_3d)

#endregion

#region _add_min_delay_timer, _add_fade_timer, _process, _node_to_label

## [b]Creates a [Timer] for the minimum delay until that sound can be played again[/b] [br]
## [br]
## [param label]: The label that the Minimum delay [Timer] should be associated with[br]
func _add_min_delay_timer(label : Labels):
	var setting = label_to_setting[label]
	var min_delay_timer : Timer = Timer.new()
	min_delay_timer.name = Labels.keys()[label] + "MinDelayTimer"
	min_delay_timer.wait_time = setting.min_delay
	min_delay_timer.autostart = true
	min_delay_timer.timeout.connect(min_delay_timer.queue_free)
	add_child(min_delay_timer)

## [b]Creates a [Timer] for fading under an [AudioStreamPlayer][/b] [br]
## [br]
## [param audio_stream_player]: The [AudioStreamPlayer] that the [Timer] should be a child of [br]
## [b]type[/b]: The type of fade that the [Timer] is (Either [code]unpause[/code], [code]pause[/code], or [code]clear[/code]) [br]
## [b]length[/b]: The value that [member Timer.wait_time] will be
func _add_fade_timer(audio_stream_player : AudioStreamPlayer, type : String, length : float):
	var timer : Timer = Timer.new()
	timer.name = audio_stream_player.name + type
	timer.wait_time = length
	timer.autostart = true
	timer.one_shot = true
	audio_stream_player.add_child(timer)

func _process(_delta):
	for node in get_children():
		if node is not AudioStreamPlayer:
			continue
		
		for timer in node.get_children():
			var type : String
			if "unpause" in timer.name:
				type = "unpause"
			elif "pause" in timer.name:
				type = "pause"
			elif "clear" in timer.name:
				type = "clear"
				
			if timer.time_left > 0:
				var volume : float = label_to_setting[_node_to_label(node)].volume
				if type == "unpause":
					node.stream_paused = false
					node.volume_db = linear_to_db(preload("uid://b558ipjpf7jwo").sample(timer.time_left / timer.wait_time)) + volume
				if type == "pause" or type == "clear":
					node.volume_db = linear_to_db(preload("uid://d2651b3sfawfp").sample(timer.time_left / timer.wait_time)) + volume
					
			if timer.time_left == 0:
				timer.queue_free()
				if type == "unpause":
					node.stream_paused = false
				if type == "pause":
					node.stream_paused = true
				if type == "clear":
					node.queue_free()

## [b]Accepts a node of type [AudioStreamPlayer], and returns its associated label.[/b] [br]
## [br]
## [param audio_stream_player]: The [AudioStreamPlayer] whos label will be returned
func _node_to_label(audio_stream_player : AudioStreamPlayer):
	var text = audio_stream_player.name.remove_chars("1234567890")
	text = text.to_upper()
	return Labels[text]
#endregion
