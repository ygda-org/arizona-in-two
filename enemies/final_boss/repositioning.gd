extends Node2D
class_name BossRepositioning

@export var travel_distance: float
@export var travel_speed: float = 200.0

var target_position: Vector2
var dir = Vector2i(1,0)

var active: bool = false

func activate():
	var random_init_target = Vector2(travel_distance, 0).rotated(randi_range(0,3) * PI / 2)
	for i in range(4):
		$WallCheck.target_position = random_init_target.rotated(i * PI/2) * 1.1
		$WallCheck.force_raycast_update()
		if not $WallCheck.is_colliding():
			target_position = $WallCheck.target_position + get_parent().get_parent().global_position
			break
	dir = Vector2i($WallCheck.target_position.normalized())
	
	active = true

func deactivate():
	active = false
