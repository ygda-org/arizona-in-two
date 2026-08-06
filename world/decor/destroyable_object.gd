extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var died = false

func _ready():
	animated_sprite_2d.play("default")
	$DamageComponent.health = 1.0

func damaged_sequence():
	pass # Hurt Animation

func suicide():
	if died == false:
		died = true
		animated_sprite_2d.play("death")
		$Hitbox.queue_free()
