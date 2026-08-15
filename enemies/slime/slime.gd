extends CharacterBody2D

const ACCEL : float = 20.0
const IDLE_SPEED : float = 20.0
const CHASE_SPEED : float = 30.0
const DASH_STRENGTH : float = 1200.0
var target_velocity : Vector2 = Vector2.ZERO
#idle
#chase
#dash
var state : String = "idle"

@onready var particles = $CPUParticles2D

var player_in_range : bool = false

var can_attack : bool = false

@export var damage = 10

## "Normal," "Ice," or "Fire"
@export var type: String = "Normal"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$IdleTimer.wait_time = randf_range(4.0,7.0)
	$IdleTimer.start()

const DEAD_ENEMY = preload("uid://dg6vd4w76xk55")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		"idle":
			velocity = velocity.lerp(target_velocity, ACCEL * delta)
		"chase":
			target_velocity = GameState.player.global_position - global_position
			if abs(abs(target_velocity.x) - abs(target_velocity.y)) > 10:
				if abs(target_velocity.x) > abs(target_velocity.y):
					target_velocity.x = sign(target_velocity.x) * CHASE_SPEED
					target_velocity.y = 0
				else:
					target_velocity.x = 0
					target_velocity.y = sign(target_velocity.y) * CHASE_SPEED
				velocity = target_velocity
		"dash":
			can_attack = true
			velocity = velocity.lerp(target_velocity, ACCEL * delta)
			if velocity.length_squared() < 0.01 and $DashTimer.is_stopped():
				modulate = Color(1.0,1.0,1.0)
				state = "idle"
				$IdleTimer.start()
	
	# Particles only show up when moving
	particles.emitting = velocity.length_squared() > 0
	move_and_slide()

	if player_in_range and velocity == Vector2(0,0) and $MinDelayAttackTimer.time_left == 0 and can_attack:
		can_attack = false
		$MinDelayAttackTimer.start()
		GameState.damage_player(damage)
		if type == "Fire":
			GameState.player.apply_fire()
		if type == "Ice":
			GameState.player.apply_ice()

func _on_idle_timer_timeout() -> void:
	if target_velocity == Vector2.ZERO:
		var rand_num : int = randi_range(0,3)
		match rand_num:
			0:
				target_velocity = Vector2.UP * IDLE_SPEED
			1:
				target_velocity = Vector2.DOWN * IDLE_SPEED
			2:
				target_velocity = Vector2.LEFT * IDLE_SPEED
			3:
				target_velocity = Vector2.RIGHT * IDLE_SPEED
		$IdleTimer.wait_time = randf_range(0.5,1.5)
	else:
		target_velocity = Vector2.ZERO
		$IdleTimer.wait_time = randf_range(1.25,3.0)
	$IdleTimer.start()

func _on_target_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	if state == "dash":
		return
	state = "chase"
	target_velocity = GameState.player.global_position - global_position
	if abs(target_velocity.x) > abs(target_velocity.y):
		target_velocity.x = sign(target_velocity.x) * CHASE_SPEED
		target_velocity.y = 0
	else:
		target_velocity.x = 0
		target_velocity.y = sign(target_velocity.y) * CHASE_SPEED
	velocity = target_velocity
	$IdleTimer.stop()


func _on_chase_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	if state == "dash":
		return
	state = "idle"
	target_velocity = Vector2.ZERO
	$IdleTimer.wait_time = randf_range(2.0,4.0)
	$IdleTimer.start()


func _on_enemy_component_dead() -> void:
	#Uncomment once there is a death animation
	#$Anim.play("death")
	#await $Anim.animation_finished
	var dead_body = DEAD_ENEMY.instantiate()
	dead_body.position = position
	dead_body.type = "slime_dead"
	dead_body.set_type()
	get_parent().add_child(dead_body)
	queue_free()


func _on_dash_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	state = "dash"
	target_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	modulate = Color(1.0,0.0,0.0)
	$DashTimer.start()


func _on_dash_timer_timeout() -> void:
	target_velocity = GameState.player.global_position - global_position
	if abs(target_velocity.x) > abs(target_velocity.y):
		target_velocity.x = sign(target_velocity.x) * DASH_STRENGTH
		target_velocity.y = 0
	else:
		target_velocity.x = 0
		target_velocity.y = sign(target_velocity.y) * DASH_STRENGTH
	velocity = target_velocity
	target_velocity = Vector2.ZERO


func _on_damage_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true


func _on_damage_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
