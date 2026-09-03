extends Node2D

var direction: Vector2i = Vector2i(1,0)
var position_current: Vector2 = Vector2(0,0)

const SPIKE_SIZE = 16.0

const SPIKE = preload("uid://coip13emt7e8v")

var timer_modifier_amount : float
var timer_variation : bool = false
var timer_modifier_total : float = 0

func _ready():
	for i in range(30):
		timer_modifier_total += timer_modifier_amount
		create_spike()

func create_spike():
	position_current += SPIKE_SIZE * direction
	var spike = SPIKE.instantiate()
	spike.position = position_current
	spike.timer_modifier = timer_modifier_total
	spike.timer_variation = timer_variation
	add_child(spike)
