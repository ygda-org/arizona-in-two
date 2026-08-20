extends Node2D

const TRAIL_BULLET = preload("uid://dk37b1wotxqbv")

func activate():
	#if randi_range(0,1):
	#	get_parent().get_parent().next_state()
	#	return
	var side = randi_range(0,1) * 2 - 1
	var h_offset = randi_range(-25, 25) + 300
	for i in range(14):
		var bullet = TRAIL_BULLET.instantiate()
		bullet.global_position.y = 200 * side + 300
		bullet.direction = Vector2i(-bullet.global_position.normalized()*2)
		bullet.global_position.x = -300 + i * 50 + h_offset
		$Shots.add_child(bullet)
	var side2 = randi_range(0,1) * 2 - 1
	var v_offset = randi_range(-25, 25) + 150
	for i in range(10):
		var bullet = TRAIL_BULLET.instantiate()
		bullet.global_position.x = 350 * side2 + 150
		bullet.direction = Vector2i(-bullet.global_position.normalized()*2)
		bullet.global_position.y = -300 + i * 50 + v_offset
		$Shots.add_child(bullet)
	get_parent().get_parent().play_anim_by_dir("attack_", Vector2i(0, side2))
	get_parent().get_parent().queue_anim_by_dir("attack_", Vector2i(side, 0))
	await get_tree().create_timer(3.0).timeout
	get_parent().get_parent().next_state()

func deactivate():
	pass
