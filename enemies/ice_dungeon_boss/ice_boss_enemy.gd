extends Node2D

@onready var current_state = 0

@onready var states = $States

func _ready():
	if GameState.ice_dungeon_boss_cleared:
		queue_free()
	$States/Wall.activate()
	for piece in $Pieces.get_children():
		piece.destroyed.connect(piece_destroyed)

func next_state():
	states.get_child(current_state).deactivate()
	current_state = (current_state + 1) % len(states.get_children())
	states.get_child(current_state).activate()

func piece_destroyed():
	if len($Pieces.get_children()) < 4 and states == $States:
		states.get_child(current_state).deactivate()
		states = $States2
		current_state = 0
		next_state()
	if len($Pieces.get_children()) < 2:
		GameState.ice_dungeon_boss_cleared = true
		queue_free()
