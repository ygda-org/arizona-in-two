extends CharacterBody2D

@export var generation: int

@export var direction: Vector2

const SPEED : float = 50.0

var initial_position

const TUMBLEWEED = preload("res://enemies/tumbleweed/tumbleweed.tscn")


func _ready():
	initial_position = global_position
	$GrowthTimer.wait_time = randf_range(10,15)
	$GrowthTimer.start()

func _physics_process(delta):
	if initial_position.distance_to(global_position) < 30:
		velocity += direction * SPEED * delta
	else:
		velocity = Vector2(0,0)
	
	move_and_slide()


func _on_growth_timer_timeout():
	var tumble = TUMBLEWEED.instantiate()
	get_parent().add_child(tumble)
	tumble.position = position
	tumble.name = name + "Tumble"
	tumble.generation = generation
	queue_free()
