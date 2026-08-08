extends Node2D

const BULLET = preload("uid://g41ejapawsb5")
const TELEGRAPH_LINE = preload("uid://c70a6tty5ockd")

@export var total_shot_count: int
@export var shot_cd: float
@export var bullet_speed: float
@export var burst_amount: int

var shot_count: int = 0

func activate():
	shot_count = 0
	$Timer.wait_time = shot_cd
	$Timer.start()

func deactivate():
	$Timer.stop()


func _on_timer_timeout():
	for i in range(burst_amount):
		shot_count += 1
		var bullet = BULLET.instantiate()
		var telegraph = TELEGRAPH_LINE.instantiate()
		var spawn_pos
		if randi_range(0,1):
			spawn_pos = Vector2(0, -400 * (randi_range(0,1)*2-1)) # 
		else:
			spawn_pos = Vector2(-550 * (randi_range(0,1)*2-1), 0)
		$Shots.add_child(telegraph)
		telegraph.rotation = spawn_pos.angle() - PI/2
		bullet.velocity = -spawn_pos.normalized() * bullet_speed
		if spawn_pos.x:
			spawn_pos.y = randf_range(-80,80)
		else:
			spawn_pos.x = randf_range(-180,180)
		telegraph.global_position = spawn_pos
		bullet.get_node("BulletWallCollisions").collision_mask = 0
		$Shots.add_child(bullet)
		bullet.global_position = spawn_pos
		if shot_count >= total_shot_count:
			get_parent().get_parent().next_state()
			return
