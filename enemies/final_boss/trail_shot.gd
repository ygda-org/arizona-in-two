extends Node2D

@export var bullet_speed: float

const BULLET = preload("uid://dk37b1wotxqbv")

const SHOT_DIRECTIONS = [Vector2i(1,0), Vector2i(1,1), 
Vector2i(0,1), Vector2i(-1,1),
Vector2i(-1,0), Vector2i(-1,-1),
Vector2i(0,-1), Vector2i(1,-1)]

func activate():
	var player = GameState.player
	var dir = global_position.direction_to(player.global_position)
	var closest_dir = SHOT_DIRECTIONS[0]
	for direction in SHOT_DIRECTIONS:
		if Vector2(direction).normalized().distance_to(dir) < Vector2(closest_dir).normalized().distance_to(dir):
			closest_dir = direction
	dir = closest_dir
	get_parent().get_parent().play_anim_by_dir("", dir)
	await get_tree().create_timer(0.3).timeout
	get_parent().get_parent().play_anim_by_dir("attack_", dir)
	await get_tree().create_timer(0.5).timeout
	dir = Vector2(dir)
	var bullet = BULLET.instantiate()
	bullet.direction = dir
	bullet.global_position = global_position
	$Bullets.add_child(bullet)
	await get_tree().create_timer(1.0).timeout
	get_parent().get_parent().next_state()

func deactivate():
	pass
