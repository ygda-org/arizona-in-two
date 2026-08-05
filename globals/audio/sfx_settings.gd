extends Resource
class_name SfxSettings

##The Audio Bus for the audio to be played on.
@export var bus: String
## The AudioStream to be played
@export var stream: AudioStream
## Volume in decibels.
@export var volume: float = 0.0
## A random value will picked between [code]volume_variance[/code] amd [code]volume_variance * -1[/code] 
## each time [method sfx_player.play] is called. This value is added to volume of the audio played.
@export var volume_variance: float = 0.0
## The pitch scale, defined in semitones. Note that this will change the speed of the audio (negligle at low values)
@export var pitch: float = 1.0
## A random value will picked between [code]pitch_variance[/code] amd [code]pitch_variance * -1[/code] 
## each time [method sfx_player.play] is called. This value is added to pitch of the audio played.
@export var pitch_variance: float = 0.0
## Minimum delay between repeated instances playing. 0.0 means no delay. [code]Default: 0.0[/code]
@export var min_delay : float = 0.0
