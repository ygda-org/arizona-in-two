extends Node2D

@export var phase_dur: float = 2.5
@export var max_spikes: int = 20
@export var spawn_attempt_amount: int = 17

const ICE_SPIKE = preload("uid://bc4df4v86bpt2")

func activate():
	var spike_positions = []
	for i in range(spawn_attempt_amount):
		var attempt_pos = Vector2(randf_range(-100,100), randf_range(-175, -15))
		var is_too_close = false
		for pos in spike_positions:
			if attempt_pos.distance_to(pos) < 20:
				is_too_close = true
		if is_too_close or len($Spikes.get_children()) > max_spikes:
			continue
		spike_positions.append(attempt_pos)
		var ice_spike = ICE_SPIKE.instantiate()
		ice_spike.persist_break = false
		ice_spike.global_position = attempt_pos
		ice_spike.y_sort_enabled = true
		$Spikes.add_child(ice_spike)
	await get_tree().create_timer(phase_dur).timeout
	get_parent().get_parent().next_state()
