extends CharacterBody2D

func _ready():
	$DamageComponent.health = 1.0

func damaged_sequence():
	pass # Hurt Animation

func suicide():
	queue_free() # Death Animation
