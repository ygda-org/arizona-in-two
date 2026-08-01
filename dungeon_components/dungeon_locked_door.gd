@tool

extends Node2D

@export var door_id: String = ""

enum DIRECTIONS {
	NORTH,
	EAST,
	SOUTH,
	WEST
}

@export var direction: DIRECTIONS:
	set(new_dir):
		direction = new_dir
		rotate_to_dir(new_dir)

func _ready():
	rotate_to_dir(direction)
	if Engine.is_editor_hint():
		return
	if door_id in GameState.persist_unlocked_doors:
		queue_free()

func rotate_to_dir(dir):
	rotation = dir * PI/2

func unlock():
	GameState.player_keys -= 1
	GameState.persist_unlocked_doors.append(door_id)
	queue_free()


func _on_unlock_zone_body_entered(body):
	if GameState.player_keys and not Engine.is_editor_hint():
		unlock()
