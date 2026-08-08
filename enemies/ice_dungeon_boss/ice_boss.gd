extends CharacterBody2D

@onready var current_state = 0

@onready var states = $States

func _ready():
	if GameState.ice_dungeon_boss_cleared:
		queue_free()
	$States/Wall.activate()

func damaged_sequence():
	pass

func suicide():
	pass

func next_state():
	current_state = (current_state + 1) % len(states.get_children())
	states.get_child(current_state).activate()
