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
	var h_offset = randi_range(-25, 25)
	for i in range(12):
		var bullet = BULLET.instantiate()
		bullet.get_node("BulletWallCollisions").collision_mask = 0
		bullet.global_position.y = 200 * side
		bullet.velocity = -bullet.global_position.normalized() * bullet_speed
		bullet.global_position.x = -300 + i * 50 + h_offset
		var telegraph = TELEGRAPH_LINE.instantiate()
		telegraph.global_position = bullet.global_position
		$Shots.add_child(telegraph)
		$Shots.add_child(bullet)
		telegraph.rotation = bullet.rotation - PI / 2
	var side2 = randi_range(0,1) * 2 - 1
	var v_offset = randi_range(-25, 25)
	for i in range(8):
		var bullet = BULLET.instantiate()
		bullet.get_node("BulletWallCollisions").collision_mask = 0
		bullet.global_position.x = 200 * side2
		bullet.velocity = -bullet.global_position.normalized() * bullet_speed
		bullet.global_position.y = -300 + i * 50 + v_offset
		var telegraph = TELEGRAPH_LINE.instantiate()
		telegraph.global_position = bullet.global_position
		$Shots.add_child(bullet)
		telegraph.rotation = bullet.rotation - PI/2
		$Shots.add_child(telegraph)
	shot_amount += 1
	if shot_amount >= total_shot_amount:
		get_parent().get_parent().next_state
