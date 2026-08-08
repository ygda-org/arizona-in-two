extends CharacterBody2D

@export var speed: float = 500.0

@export var attackDmg: float = 15.0

var targetAngle: Vector2 = [Vector2(1,0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)][randi_range(0,3)]
var canMove: bool = false
var shouldMove: bool = true

var player: CharacterBody2D = null
var player_LastKnownPosition: Vector2 = Vector2.ZERO

var spread: float = PI/6

var mode: String = "Idle"

const DEAD_BODY = preload("uid://dg6vd4w76xk55")

@onready var timer: Timer = $"Movement Timer"
@onready var delay: Timer = $"Movement Delay"
@onready var attackTimer: Timer = $"Attack Delay"

func _physics_process(delta: float) -> void:
	if mode == "Idle":
		if not attackTimer.is_stopped():
			return 
			
		if canMove:
			move_and_slide()
			return
		
		if not shouldMove:
			return 
			
		velocity = speed * targetAngle * delta
		targetAngle = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP][randi_range(0,3)]
		timer.wait_time = randf_range(10.0, 15.0)
		timer.start()
		canMove = true
		shouldMove = false
		
	elif mode == "Attack":
		attack()

func attack():
	if attackTimer.is_stopped():
		attackTimer.start()

func damaged_sequence():
	pass # Hurt Animation

func suicide():
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	var dead_body = DEAD_BODY.instantiate()
	dead_body.type = "tumbleweed_dead"
	dead_body.set_type()
	get_parent().add_child(dead_body)
	dead_body.position = position
	dead_body.name = "Dead" + name
	queue_free()

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("Player"):
		player = body
		mode = "Attack"

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("Player"):
		player_LastKnownPosition = player.position
		player = null
		mode = "Idle"

func _on_movement_timer_timeout() -> void:
	canMove = false
	delay.wait_time = randf_range(0.1, 5.0)
	delay.start()
	

func _on_attack_delay_timeout() -> void:
	var bullet1 = load("res://enemies/tumbleweed/tumble_bullet.tscn").instantiate()
	var bullet2 = load("res://enemies/tumbleweed/tumble_bullet.tscn").instantiate()
	var bullet3 = load("res://enemies/tumbleweed/tumble_bullet.tscn").instantiate()
	
	bullet1.originalPosition = position
	bullet2.originalPosition = position
	bullet3.originalPosition = position
	
	bullet1.position = position
	bullet2.position = position
	bullet3.position = position
	
	if player == null:
		bullet1.direction = (player_LastKnownPosition - position)
		bullet2.direction = (player_LastKnownPosition - position).rotated(spread)
		bullet3.direction = (player_LastKnownPosition - position).rotated(-spread)
	else:
		bullet1.direction = (player.position - position)
		bullet2.direction = (player.position - position).rotated(spread)
		bullet3.direction = (player.position - position).rotated(-spread)
	
	get_parent().add_child(bullet1)
	get_parent().add_child(bullet2)
	get_parent().add_child(bullet3)


func _on_movement_delay_timeout() -> void:
	shouldMove = true
