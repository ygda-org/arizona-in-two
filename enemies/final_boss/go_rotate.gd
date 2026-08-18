extends Node2D

@export var travel_speed: float = 200.0

var active = false

const POSITIONS = [Vector2(500,200), Vector2(500, 75), 
Vector2(300, 75), Vector2(100, 75),
Vector2(100, 200), Vector2(100, 300),
Vector2(300, 300), Vector2(500, 300)]
var current_position: int

var rotate_dir: int

@onready var target_position: Vector2 = POSITIONS.pick_random()
var dir: Vector2i = Vector2i(1,0)

func _ready():
	rotate_dir = randi_range(0,1)*2-1

func activate():
	active = true
	current_position = posmod(current_position + rotate_dir, POSITIONS.size())
	target_position = POSITIONS[current_position]
	dir = Vector2i(1.9*(target_position - get_parent().get_parent().global_position).normalized())

func deactivate():
	active = false
