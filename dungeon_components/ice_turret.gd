extends StaticBody2D

@export var shot_time: float = 2.0
@export var shot_dir: Vector2 = Vector2(1,0)

@export var bullet_speed: float = 100.0
@export var bullet_damage: int = 10

## literally just for a demo lol
@export var speed_up_after_player_collects_bullet_time: bool = false


const BULLET = preload("uid://g41ejapawsb5")

func _ready():
	$Timer.wait_time = shot_time
	if speed_up_after_player_collects_bullet_time and GameState.bullet_time_obtained:
		$Timer.wait_time = 0.5
	$Timer.start()


func _on_timer_timeout():
	var bullet = BULLET.instantiate()
	bullet.velocity = bullet_speed * shot_dir
	bullet.damage = bullet_damage
	add_child(bullet)
