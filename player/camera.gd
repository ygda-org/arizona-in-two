@tool
extends CharacterBody2D

@export var zoom: float = 3.0:
	set(new_zoom):
		zoom = new_zoom
		_ready()

const FOLLOW_STRENGTH = 0.8
var shapes = []
var monitors = []

var target_glide_position
var glide_speed
var lock_on_end

var target_rail_dir

var camera_lock: bool = false

var init_pos: bool = false

func _ready():
	$Camera2D.zoom = Vector2(zoom,zoom)
	global_position = get_parent().global_position
	#for node in get_children():
	#	if node is CollisionShape2D:
	#		shapes.append(node)
	#		node.position /= zoom
	#		var monitor: Area2D = Area2D.new()
	#		$Monitors.add_child(monitor)
	#		monitor.add_child(node.duplicate())
	#		monitor.collision_mask = collision_mask
	#		monitor.collision_layer = collision_mask
	#		monitors.append(monitor)

func _physics_process(delta):
	if camera_lock or Engine.is_editor_hint():
		return
	if glide_speed:
		velocity = global_position.direction_to(target_glide_position) * glide_speed
		position += velocity * delta
		if (position-target_glide_position).length() < 10:
			glide_speed = 0
			set_camera_lock(lock_on_end)
		return
	#velocity = global_position.lerp(get_parent().global_position, delta*FOLLOW_STRENGTH)
	velocity = FOLLOW_STRENGTH * global_position.direction_to(get_parent().global_position) * global_position.distance_to(get_parent().global_position)
	velocity *= pow(13, (get_parent().global_position - global_position).length()/(get_window().size.length()/zoom))
	if (global_position - get_parent().global_position).length() < 50:
		velocity = Vector2.ZERO
	var collision
	if target_rail_dir:
		if (global_position - get_parent().global_position).project(target_rail_dir).length() < 50:
			velocity = Vector2.ZERO
		collision = move_and_collide(delta*velocity.project(target_rail_dir))
	else: 
		collision = move_and_collide(velocity * delta)
	if collision:
		#if collision.get_normal()*-1 != collision.get_local_shape().position.normalized():
		#	position += velocity*delta
		#	collision.get_local_shape().disabled = true
		#else:
		move_and_collide(collision.get_remainder().slide(collision.get_normal()))
	#for i in range(len(shapes)): 
	#	var area: Area2D = monitors[i]
	#	if not area.get_overlapping_bodies():
	#		shapes[i].disabled = false
			
func set_glide_position(global_pos: Vector2, speed: float, lock_on_finish:bool):
	target_glide_position = global_pos
	glide_speed = speed
	lock_on_end = lock_on_finish

func set_camera_lock(boolean: bool):
	camera_lock = boolean

func set_camera_rail(rail_dir: Vector2, rail_pos: Vector2):
	$Camera2D.drag_horizontal_enabled = false
	$Camera2D.drag_vertical_enabled = false
	global_position = rail_pos
	target_rail_dir = rail_dir
	$Camera2D.drag_horizontal_enabled = true
	$Camera2D.drag_vertical_enabled = true

func force_set_position(pos):
	$Camera2D.drag_horizontal_enabled = false
	$Camera2D.drag_vertical_enabled = false
	$Camera2D.global_position = pos
	$Camera2D.drag_horizontal_enabled = true
	$Camera2D.drag_vertical_enabled = true
	camera_lock = true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	global_position = get_parent().global_position
	var min_pos = Vector2(99999,99999)
	for pos in GameState.loaded_camera_spawns:
		if global_position.distance_to(pos) < global_position.distance_to(min_pos):
			min_pos = pos
	global_position = min_pos
