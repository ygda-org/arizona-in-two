extends CharacterBody2D

@onready var current_state = 0

@onready var states = $States2

const VEC_TO_DIR = {Vector2i(1,0.0): "right", Vector2i(-1.0, 0.0): "left", Vector2i(0.0, 1.0): "down", Vector2i(0.0, -1.0): "up"}

func _ready():
	states.get_node("Repositioning").activate()

func _physics_process(_delta):
	for node in states.get_children():
		if node is BossRepositioning and node.active:
			play_anim_by_dir("run_", node.dir)
			velocity = node.travel_speed * global_position.direction_to(node.target_position)
			move_and_slide()
			if global_position.distance_to(node.target_position) < 10:
				next_state()
			break

func next_state():
	states.get_child(current_state).deactivate()
	current_state = (current_state + 1) % len(states.get_children())
	states.get_child(current_state).activate()

func play_anim_by_dir(anim_name, dir):
	$Anim.play(anim_name + VEC_TO_DIR[dir])

func next_phase():
	states.get_child(current_state).deactivate()
	states = $States2
	current_state = 0
	next_state()
