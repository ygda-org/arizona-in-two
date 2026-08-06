extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("default")
	$DamageComponent.health = 1.0

func damaged_sequence():
	pass # Hurt Animation

func suicide():
	animated_sprite_2d.play("death")
