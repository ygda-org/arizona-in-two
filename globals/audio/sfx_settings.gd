extends Resource

class_name SFXSettings

enum SFX_LABEL{
	ButtonPress,
	CycleCylinder,
	DoorClose,
	DoorOpen,
	EmptyShot,
	FireAmbient,
	Flame,
	Freeze,
	GrassStep,
	Gunshot,
	HitSound,
	MagmaStep,
	SecretSound,
	SnowFootsteps,
	Swing1,
	Swing2,
	ThickReload,
	ThinReload,
}

@export var label : SFX_LABEL
@export var stream : AudioStream
@export_range(-40,24) var volume : float = 1.0
@export_range(0.01, 4.0) var pitch : float = 1.0
@export var audio_start_offset : float = 0.0
