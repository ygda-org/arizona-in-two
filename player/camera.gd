extends CharacterBody2D

@export var zoom: float = 3.0

const FOLLOW_STRENGTH = 100

func _ready():
	$Camera2D.zoom = Vector2(zoom,zoom)
	$CollisionShape2D.scale = Vector2(1/zoom,1/zoom)
	$Area2D.add_child($CollisionShape2D.duplicate())

func _physics_process(delta):
	#velocity = global_position.lerp(get_parent().global_position, delta*FOLLOW_STRENGTH)
	velocity = FOLLOW_STRENGTH * global_position.direction_to(get_parent().global_position)
	if (global_position - get_parent().global_position).length() < 30:
		velocity = Vector2.ZERO
	if $Area2D.get_overlapping_bodies():
		position += velocity * delta
	else:
		move_and_slide()
