extends Node2D

const BULLET = preload("uid://g41ejapawsb5")
const TELEGRAPH_LINE = preload("uid://c70a6tty5ockd")

@export var frequency: float
@export var bullet_speed: float
@export var total_shot_amount: int

var shot_amount: int = 0

func activate():
	shot_amount = 0
	$Timer.wait_time = frequency
	$Timer.start()

func deactivate():
	$Timer.stop()

func _on_timer_timeout():
	var side = randi_range(0,1) * 2 - 1
	var hole_positions = []
	hole_positions.append(Vector2(randi_range(-9, 9), randi_range(-5, 5)))
	hole_positions.append(Vector2(randi_range(-9, 0), randi_range(-5, 0)))
	hole_positions.append(Vector2(randi_range(0, 9), randi_range(-5, 0)))
	hole_positions.append(Vector2(randi_range(0, 9), randi_range(0, 5)))
	hole_positions.append(Vector2(randi_range(-9, 0), randi_range(0, 5)))
	
	for i in range(30):
		var safe_pos = false
		for pos in hole_positions:
			if pos.x == i-15:
				safe_pos = true
		if safe_pos:
			continue
		var bullet = BULLET.instantiate()
		bullet.get_node("BulletWallCollisions").collision_mask = 0
		bullet.global_position.y = 200 * side
		bullet.velocity = -bullet.global_position.normalized() * bullet_speed
		bullet.global_position.x = -300 + i * 20
		var telegraph = TELEGRAPH_LINE.instantiate()
		telegraph.global_position = bullet.global_position
		$Shots.add_child(telegraph)
		$Shots.add_child(bullet)
		telegraph.rotation = bullet.rotation - PI / 2
	var side2 = randi_range(0,1) * 2 - 1
	for i in range(30):
		var safe_pos = false
		for pos in hole_positions:
			if pos.y == i-15:
				safe_pos = true
		if safe_pos:
			continue
		var bullet = BULLET.instantiate()
		bullet.get_node("BulletWallCollisions").collision_mask = 0
		bullet.global_position.x = 350 * side2
		bullet.velocity = -bullet.global_position.normalized() * bullet_speed
		bullet.global_position.y = -300 + i * 20
		var telegraph = TELEGRAPH_LINE.instantiate()
		telegraph.fade_time += 1.2
		telegraph.global_position = bullet.global_position
		$Shots.add_child(bullet)
		telegraph.rotation = bullet.rotation - PI/2
		$Shots.add_child(telegraph)
	shot_amount += 1
	if shot_amount >= total_shot_amount:
		await get_tree().create_timer(3.0).timeout
		get_parent().get_parent().next_state()
