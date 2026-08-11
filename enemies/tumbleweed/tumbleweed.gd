extends CharacterBody2D

const ACCEL : float = 20.0
const IDLE_SPEED : float = 20.0
var target_velocity : Vector2 = Vector2.ZERO
#idle
var state : String = "idle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$IdleTimer.wait_time = randf_range(4.0,7.0)
	$IdleTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		"idle":
			velocity = velocity.lerp(target_velocity, ACCEL * delta)
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
