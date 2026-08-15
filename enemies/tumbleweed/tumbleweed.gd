extends CharacterBody2D

const ACCEL : float = 20.0
const IDLE_SPEED : float = 20.0
var target_velocity : Vector2 = Vector2.ZERO
#idle
var state : String = "idle"

@export var generation: int

var counter = 0

const MAX_SEEDS = 3

const GENERATION_CHANCES = {
	0 : 0.50,
	1 : 0.25,
	2 : 0.0,
}

var TUMBLEWEED_SEED: PackedScene

var on_screen = false

var dying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TUMBLEWEED_SEED = load("uid://be1q1g5ea2ltp")
	$IdleTimer.wait_time = randf_range(4.0,7.0)
	$IdleTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dying:
		return
		
	match state:
		"idle":
			velocity = velocity.lerp(target_velocity, ACCEL * delta)
	move_and_slide()

func _on_idle_timer_timeout() -> void:
	if dying: 
		return
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
	
func create_new_seed(direction: Vector2):
	var new_seed = TUMBLEWEED_SEED.instantiate()
	new_seed.generation = generation + 1
	new_seed.name = name + "Gen" + str(new_seed.generation) + "Ct" + str(counter)
	new_seed.direction = direction
	new_seed.position = position + (direction * 25)
	get_parent().add_child(new_seed)


func _on_seed_timer_timeout():
	if dying:
		return
	if on_screen:
		if counter < MAX_SEEDS:
			if randf() < GENERATION_CHANCES[generation]:
				create_new_seed(Vector2(randf_range(-1,1),randf_range(-1,1)))
				counter += 1


func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen = false

func _on_damage_area_body_entered(body):
	if dying: 
		return
	if body == GameState.player:
		GameState.damage_player(10)

func suicide():
	dying = true
	$Anim.play("death")
	await $Anim.animation_finished
	queue_free()


func _on_enemy_component_dead():
	suicide()


func _on_enemy_component_damaged():
	if dying:
		return
	$Anim.play("angry")
	await get_tree().create_timer(1.0).timeout
	$Anim.play("default")
