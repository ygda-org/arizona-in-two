extends Node2D

@export var bullet_speed: float

const BULLET = preload("uid://bb7l55p2q3sp5")

func activate():
	var player = GameState.player
	var dir = global_position.direction_to(player.global_position)
	if abs(dir.x) > abs(dir.y):
		dir = Vector2i(dir.x/abs(dir.x), 0)
	else:
		dir = Vector2i(0, dir.y/abs(dir.y))
	get_parent().get_parent().play_anim_by_dir("attack_", dir)
	await get_tree().create_timer(0.5).timeout
	dir = Vector2(dir)
	for i in range(3):
		var bullet = BULLET.instantiate()
		bullet.velocity = bullet_speed * dir.rotated((i-1) * PI/4)
		bullet.global_position = global_position
		$Bullets.add_child(bullet)
	await get_tree().create_timer(1.0).timeout
	get_parent().get_parent().next_state()

func deactivate():
	pass
