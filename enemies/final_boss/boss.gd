extends CharacterBody2D

@onready var current_state = 0

@onready var states = $States

const VEC_TO_DIR = {Vector2i(1,0.0): "right", Vector2i(-1.0, 0.0): "left", Vector2i(0.0, 1.0): "down", Vector2i(0.0, -1.0): "up"}

func _ready():
	$States/Repositioning.activate()

func _physics_process(delta):
	if $States/Repositioning and $States/Repositioning.active:
		$Anim.play("run_" + VEC_TO_DIR[$States/Repositioning.dir])
		velocity = $States/Repositioning.travel_speed * global_position.direction_to($States/Repositioning.target_position)
		move_and_slide()
		if global_position.distance_to($States/Repositioning.target_position) < 10:
			next_state()

func next_state():
	states.get_child(current_state).deactivate()
	current_state = (current_state + 1) % len(states.get_children())
	states.get_child(current_state).activate()
