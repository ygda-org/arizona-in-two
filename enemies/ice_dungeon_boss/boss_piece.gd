extends CharacterBody2D

@export var texture: Texture
@export var spriteframes: SpriteFrames
@export var flip: bool = false
@export var health_override: float = 0.0
signal destroyed

func _ready():
	if spriteframes:
		$Sprite2D.queue_free()
		$Anim.sprite_frames = spriteframes
		$Anim.play("idle")
		$Anim.flip_h = flip
	else:
		$Sprite2D.texture = texture
		$Anim.queue_free()
	if health_override:
		$DamageComponent.health = health_override

func damaged_sequence():
	pass

func suicide():
	destroyed.emit()
	if spriteframes:
		$Anim.play("death")
		await $Anim.animation_finished
	queue_free()
