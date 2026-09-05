extends Node
## How to use this SFX Manager:
##
## Setup:
## Copy all of the files inside of the "globals" folder into your project.
## Add the SCENE "sfx_player.tscn" as an autoload in your project.
##
## Use:
## When you want to add a new sound, start by loading the file into Godot.
## Add a descriptive name to the enum "Id" in sfx_player.gd.
## This name should be in ALL_CAPS.
## Go into the inspector of the node "SfxPlayer" in sfx_player.tscn.
## In the dictionary "Id_to_Setting," add a new pair of a key and a setting.
## Select your audio file as the "stream."
## Make sure to click "Add Key/Value Pair"!!
## You can now call SFX.play(SFX.Id.YOUR_ID).

# Optionally, append a comment (##) after each id to describe where it is used
## List of all sounds. Add a new id here when you add a new sound.
enum Id {
	BUTTON_HOVER, ## A button being hovered over
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
	BUTTON_CLICK, ## A button being clicked on
	WOOD_BREAK, ## The sound of the "2" sign breaking in the title screen
	GUNSHOT_QUICK, ## The GUNSHOT, but quicker
}

## [code]TRUE[/code]: Print debug messages [br]
## [code]FALSE[/code]: Do not print debug messages
const DEBUG_MESSAGES: bool = false

## Variable to make each [AudioStreamPlayer]'s name unique. 
## Increased by one when a new [AudioStreamPlayer] is instantiated.
var counter : int = 0

## A dictionary storing ids from [code]SFX.Id[/code] and the associated [code]sfx_settings.gd[/code]
@export var id_to_setting: Dictionary[Id, SfxSettings]

const SFX_PLAYER_SETTINGS = preload("uid://b1beli4j81dgt")

## [b]Play a sound in a new [AudioStreamPlayer], as defined by [param id]. This is called as[/b] [code]SFX.play(SFX.Id.NAME)[/code]. [br]
##[br]
## [param id]: The sound you want to play, defined in SFX.Id [br]
## [param loop]: Whether the sound should loop or not. [code]Default: FALSE[/code] [br]
## [param volume_mod]: Volume that is added after variation is calculated. [code]Default: 0.0[/code] [br]
## [param pitch_mod]: Pitch that is added after variation is calculated. [code]Default: 0.0[/code] [br]
## [br]
## Returns the newly instantiated [AudioStreamPlayer]
func play(id: Id, loop : bool = false, volume_mod: float = 0.0, pitch_mod: float = 0.0):
	# Checks if a min_delay_timer is in the scene tree, and if so, return early
	if has_node(Id.keys()[id] + "MinDelayTimer"):
		return
	
	## The instance of an AudioStreamPlayer
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.set_script(SFX_PLAYER_SETTINGS)
	
	## The instance of sfx_settings.gd
	var setting = id_to_setting[id]
	audio_stream_player.bus = setting.bus
	audio_stream_player.stream = setting.stream
	audio_stream_player.name = Id.keys()[id] + str(counter)
	counter += 1
	audio_stream_player.volume_db = setting.volume + randf_range(-1,1) * setting.volume_variance + volume_mod
	audio_stream_player.pitch_scale = setting.pitch + randf_range(-1,1) * setting.pitch_variance + pitch_mod
	if loop == true:
		print("loop")
		if audio_stream_player.stream is AudioStreamWAV:
			audio_stream_player.stream.loop_mode = 1
			audio_stream_player.stream.loop_end = audio_stream_player.stream.get_length() * audio_stream_player.stream.mix_rate
		elif audio_stream_player.stream is AudioStreamMP3:
			audio_stream_player.stream.loop = true
	
	add_child(audio_stream_player)
	audio_stream_player.finished.connect(audio_stream_player.queue_free)
	audio_stream_player.playing = true
	
	if DEBUG_MESSAGES:
		print("Played one sound: ", audio_stream_player)
		
	if setting.min_delay != 0:
		_add_min_delay_timer(id)
		
	return audio_stream_player
	
## [b] Play a random sound from [param Id], in a new [AudioStreamPlayer] [/b] [br]
## This is called as [code]SFX.play_random([SFX.Id.NAME1, SFX.Id.NAME2])[/code] [br]
## [br]
## [param Id]: An array of Id you want to play [br]
## [param loop]: Whether the sound should loop or not. [code]Default: FALSE[/code] [br]
## [param volume_mod]: Volume that is added after variation is calculated. [code]Default: 0.0[/code] [br]
## [param pitch_mod]: Pitch that is added after variation is calculated. [code]Default: 0.0[/code] [br]
## [br]
## Returns the newly instantiated [AudioStreamPlayer]
func play_random(ids : Array[Id] = [], loop : bool = false, volume_mod: float = 0.0, pitch_mod: float = 0.0):
	var sound : int = randi_range(0,Id.size() - 1)
	var id : Id = ids[sound]
	var node : AudioStreamPlayer = SFX.play(id, loop, volume_mod, pitch_mod)
	var keys : Array[String] = []
	for i in Id:
		keys.append(Id.find_key(i))
	print("Played random sound: ", node, ", chosen from ", keys)
	return node

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
		if node.name == Id.keys()[_node_to_id(audio_stream_player)] +  "MinDelayTimer":
			node.set_paused(false)
			
	if DEBUG_MESSAGES:
		print("Unpaused one sound: ", audio_stream_player)

## [b]Unpause all [AudioStreamPlayer]s of a specific id, with an optional fade in[/b] [br]
## [br]
## [param id]: [AudioStreamPlayer]s that use this id will be unpaused [br]
## [param fade]: Whether the audio should fade in. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade in for. [code]Default: 1.0[/code]
func unpause_type(id: Id, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if Id.keys()[id] not in node.name:
				continue
			if fade == true:
				_add_fade_timer(node, "unpause", fade_length)
			else:
				node.play()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Id.keys()[id] +  "MinDelayTimer":
			node.set_paused(false)
			
	if DEBUG_MESSAGES:
		print("Unpaused all sounds of type: ", Id.keys()[id])

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
		if node.name == Id.keys()[_node_to_id(audio_stream_player)] +  "MinDelayTimer":
			node.set_paused(true)
			
	if DEBUG_MESSAGES:
		print("Paused one sound: ", audio_stream_player)

## [b]Pause all [AudioStreamPlayer]s of a specific id, with an optional fade in[/b] [br]
## [br]
## [param id]: [AudioStreamPlayer]s that use this id will be paused [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func pause_type(id: Id, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if Id.keys()[id] not in node.name:
				continue
			if fade == true:
				_add_fade_timer(node, "pause", fade_length)
			else:
				node.stop()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Id.keys()[id] +  "MinDelayTimer":
			node.set_paused(true)
			
	if DEBUG_MESSAGES:
		print("Paused all sounds of type: ", Id.keys()[id])

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
		if node.name == Id.keys()[_node_to_id(audio_stream_player)] +  "MinDelayTimer":
			node.queue_free()
			
	if DEBUG_MESSAGES:
		print("cleared one sound: ", audio_stream_player)

## [b]Clear all [AudioStreamPlayer]s of a specific id, with an optional fade out[/b] [br]
## [br]
## [param id]: [AudioStreamPlayer]s that use this id will be cleared [br]
## [param fade]: Whether the audio should fade out. [code]Default: FALSE[/code] [br]
## [param fade_length]: In seconds, how long the sound should fade out for. [code]Default: 1.0[/code]
func clear_type(id : Id, fade: bool = false, fade_length : float = 1.0):
	for node in get_children():
		if node is AudioStreamPlayer:
			if Id.keys()[id] not in node.name:
				continue
			if fade == true:
				_add_fade_timer(node, "clear", fade_length)
			else:
				node.queue_free()
		# If the node is a MinDelayTimer, unpause it
		if node.name == Id.keys()[id] +  "MinDelayTimer":
			node.queue_free()
			
	if DEBUG_MESSAGES:
		print("Cleared all sounds of type: ", Id.keys()[id])

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

## [b]Attach an AudioStreamPlayer2D as a child of a node[/b] [br]
## [br]
## [param id]: The id that the [AudioStreamPlayer2D] should use [br]
## [param node]: The node that the [AudioStreamPlayer2D] should be attached on
## [param loop]: Whether the sound should loop or not. [code]Default: FALSE[/code] [br]
## [br]
## Returns the newly instantiated [AudioStreamPlayer2D]
func play_2d(id : Id, node : Node, loop : bool = false):
	var setting = id_to_setting[id]
	var audio_stream_player_2d : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_stream_player_2d.stream = setting.stream
	audio_stream_player_2d.volume_db = setting.volume + randf_range(-1,1) * setting.volume_variance
	audio_stream_player_2d.pitch_scale = setting.pitch +  + randf_range(-1,1) * setting.pitch_variance
	audio_stream_player_2d.bus = setting.bus
	node.add_child(audio_stream_player_2d)
	audio_stream_player_2d.playing = true
	
	if loop == true:
		if audio_stream_player_2d.stream is AudioStreamWAV:
			audio_stream_player_2d.stream.loop_mode = 1
		elif audio_stream_player_2d.stream is AudioStreamMP3:
			audio_stream_player_2d.stream.loop = true
	
	return audio_stream_player_2d

## [b]Attach an AudioStreamPlayer3D as a child of a node[/b] [br]
## [br]
## [param id]: The id that the [AudioStreamPlayer3D] should use [br]
## [param node]: The node that the [AudioStreamPlayer3D] should be attached on
## [param loop]: Whether the sound should loop or not. [code]Default: FALSE[/code] [br]
## [br]
## Returns the newly instantiated [AudioStreamPlayer3D]
func play_3d(id : Id, node : Node, loop : bool = false):
	var setting = id_to_setting[id]
	var audio_stream_player_3d : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	
	audio_stream_player_3d.stream = setting.stream
	audio_stream_player_3d.volume_db = setting.volume + randf_range(-1,1) * setting.volume_variance
	audio_stream_player_3d.pitch_scale = setting.pitch +  + randf_range(-1,1) * setting.pitch_variance
	audio_stream_player_3d.bus = setting.bus
	
	if loop == true:
		audio_stream_player_3d.stream.loop = true
	
	node.add_child(audio_stream_player_3d)
	
	return audio_stream_player_3d

#endregion

#region _add_min_delay_timer, _add_fade_timer, _process, _node_to_id

func _add_min_delay_timer(id : Id) -> void:
	var setting = id_to_setting[id]
	var min_delay_timer : Timer = Timer.new()
	min_delay_timer.name = Id.keys()[id] + "MinDelayTimer"
	min_delay_timer.wait_time = setting.min_delay
	min_delay_timer.autostart = true
	min_delay_timer.timeout.connect(min_delay_timer.queue_free)
	add_child(min_delay_timer)

func _add_fade_timer(audio_stream_player : AudioStreamPlayer, type : String, length : float) -> void:
	for node in audio_stream_player.get_children():
		node.queue_free()
	var timer : Timer = Timer.new()
	timer.name = audio_stream_player.name + type + str(counter)
	counter += 1
	timer.wait_time = length
	timer.autostart = true
	timer.one_shot = true
	audio_stream_player.add_child(timer)
	audio_stream_player.volume_limit = audio_stream_player.volume_db

func _process(_delta) -> void:
	for node in get_children():
		if node is not AudioStreamPlayer:
			continue
		
		for timer : Timer in node.get_children():
			var type : String
			if "unpause" in timer.name:
				type = "unpause"
			elif "pause" in timer.name:
				type = "pause"
			elif "clear" in timer.name:
				type = "clear"
				
			if timer.time_left > 0:
				var volume : float = id_to_setting[_node_to_id(node)].volume
				if type == "unpause": ## Fade in
					node.stream_paused = false
					var distance_through_curve : float = (timer.wait_time - timer.time_left) / timer.wait_time
					var multiplicand : float = (db_to_linear(volume) - db_to_linear(node.volume_limit)) / db_to_linear(volume)
					var adder : float = db_to_linear(node.volume_limit - volume)
					node.volume_db = linear_to_db((distance_through_curve * multiplicand) + adder) + volume
				if type == "pause" or type == "clear": ## Fade out
					node.volume_db = linear_to_db(timer.time_left / timer.wait_time) + node.volume_limit
					
			if timer.time_left == 0:
				timer.queue_free()
				if type == "unpause":
					node.stream_paused = false
				if type == "pause":
					node.stream_paused = true
				if type == "clear":
					node.queue_free()

## [b]Accepts a node of type [AudioStreamPlayer], and returns its associated id.[/b] [br]
## [br]
## [param audio_stream_player]: The [AudioStreamPlayer] whose id will be returned
func _node_to_id(audio_stream_player : AudioStreamPlayer) -> int:
	var text : String = audio_stream_player.name.remove_chars("1234567890")
	text = text.to_upper()
	return Id[text]
#endregion
