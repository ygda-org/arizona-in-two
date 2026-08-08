extends CharacterBody2D

signal destroyed

func damaged_sequence():
	pass

func suicide():
	destroyed.emit()
	queue_free()
