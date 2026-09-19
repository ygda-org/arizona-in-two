extends CharacterBody2D

@onready var current_state = 0

@onready var states = $States

var phase_num: int = 1

const VEC_TO_DIR = {Vector2i(1,0.0): "right", Vector2i(-1.0, 0.0): "left", Vector2i(0.0, 1.0): "down", Vector2i(0.0, -1.0): "up"}

func _ready():
	if GameState.final_boss_cleared:
		queue_free()
	states.get_child(0).activate()
	$EnemyComponent.dead.connect(phase_dead)

func _physics_process(_delta):
	if not states:
		return
	for node in states.get_children():
		if "travel_speed" in node and node.active:
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
	if dir.x and dir.y:
		$Anim.play(anim_name + VEC_TO_DIR[Vector2i(dir.x, 0)])
		return
	$Anim.play(anim_name + VEC_TO_DIR[dir])

func queue_anim_by_dir(anim_name, dir):
	await $Anim.animation_finished
	if dir.x and dir.y:
		$Anim.play(anim_name + VEC_TO_DIR[Vector2i(dir.x, 0)])
		return
	$Anim.play(anim_name + VEC_TO_DIR[dir])

func next_phase():
	states.get_child(current_state).deactivate()
	states = get_node("States" + str(phase_num))
	current_state = 0
	next_state()

func phase_dead():
	phase_num += 1
	if phase_num < 4:
		$EnemyComponent.health = 150
		next_phase()
	else:
		states = null
		$States.queue_free()
		$States2.queue_free()
		$States3.queue_free()
		$CollisionShape2D.queue_free()
		$EnemyComponent.queue_free()
		velocity = Vector2.ZERO
		$Anim.play("death")
		await $Anim.animation_finished
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 2.5)
		tween.tween_callback(GameState.final_boss_clear)
		tween.tween_callback(get_parent().get_node("BossArenaController").boss_clear)
		tween.tween_callback(queue_free)
