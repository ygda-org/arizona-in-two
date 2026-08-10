extends CharacterBody2D

const ACCEL : float = 20.0
const IDLE_SPEED : float = 20.0
const CHASE_SPEED : float = 30.0
var target_velocity : Vector2 = Vector2.ZERO
#idle
#chase
#dash
var state : String = "idle"

@onready var particles = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$IdleTimer.wait_time = randf_range(4.0,7.0)
	$IdleTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		"idle":
			velocity = velocity.lerp(target_velocity, ACCEL * delta)
		"chase":
			target_velocity = GameState.player.global_position - global_position
			if abs(abs(target_velocity.x) - abs(target_velocity.y)) > 10:
				if abs(target_velocity.x) > abs(target_velocity.y):
					target_velocity.y = 0
				else:
					target_velocity.x = 0
				print(target_velocity)
				velocity = target_velocity.normalized() * CHASE_SPEED
		"dash":
			velocity = velocity.lerp(target_velocity, ACCEL * delta)
	
	# Particles only show up when moving
	particles.emitting = velocity.length() > 0
	move_and_slide()

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
	state = "chase"
	target_velocity = Vector2.ZERO
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
	queue_free()


func _on_dash_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	state = "chase"
	target_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	$DashTimer.start()
