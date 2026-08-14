extends Node2D

@export var bullet_speed: float

const BULLET = preload("uid://dk37b1wotxqbv")

func activate():
	var player = GameState.player
	var dir = global_position.direction_to(player.global_position)
	if abs(dir.x) > abs(dir.y):
		dir = Vector2i(dir.x/abs(dir.x), 0)
	else:
		dir = Vector2i(0, dir.y/abs(dir.y))
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
