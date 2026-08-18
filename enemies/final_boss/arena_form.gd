extends Node2D

@export var arena_center: Vector2

const SPIKE = preload("uid://coip13emt7e8v")

const RING_COUNT = 10

func activate():
	if $Arena.get_children().size() > 0:
		get_parent().get_parent().next_state()
		return
	for i in range(RING_COUNT):
		for j in range(50):
			var spike = SPIKE.instantiate()
			spike.position = arena_center + Vector2(250-i*16, 0).rotated(j*PI/25)
			if i > 4:
				spike.fade_out = false
			$Arena.add_child(spike)
		await get_tree().create_timer(0.5).timeout
	get_parent().get_parent().next_state()
