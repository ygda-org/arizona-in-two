extends CharacterBody2D

@export var zoom: float = 3.0

const FOLLOW_STRENGTH = 100
var shapes = []
var monitors = []

func _ready():
	$Camera2D.zoom = Vector2(zoom,zoom)
	for node in get_children():
		if node is CollisionShape2D:
			shapes.append(node)
			node.position /= zoom
			var monitor: Area2D = Area2D.new()
			$Monitors.add_child(monitor)
			monitor.add_child(node.duplicate())
			monitor.collision_mask = collision_mask
			monitor.collision_layer = collision_mask
			monitors.append(monitor)

func _physics_process(delta):
	#velocity = global_position.lerp(get_parent().global_position, delta*FOLLOW_STRENGTH)
	velocity = FOLLOW_STRENGTH * global_position.direction_to(get_parent().global_position)
	if (global_position - get_parent().global_position).length() < 30:
		velocity = Vector2.ZERO
	#if $Area2D.get_overlapping_bodies():
		#position += velocity * delta
	#else:
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_normal()*-1 != collision.get_local_shape().position.normalized():
			position += velocity*delta
			collision.get_local_shape().disabled = true
		else:
			move_and_collide(collision.get_remainder().slide(collision.get_normal()))
	for i in range(len(shapes)): 
		var area: Area2D = monitors[i]
		if not area.get_overlapping_bodies():
			shapes[i].disabled = false
			
