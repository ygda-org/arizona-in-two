extends CharacterBody2D
## A basic slime enemy.
##
## When placed in a scene, the slime's movement calculations are paused until
## the rectangle defined in [VisibleOnScreenEnabler2D] enters the screen.[br][br]
##
## When movement is enabled, the slime will move randomly in its idle state and
## will damage the player on contact. If a [member chase_area] is set, then the
## slime will "chase" the player when they enter the [Area2D].

## The slime's idle movement speed.
@export var idle_speed: float = 10.0

## The slime's chase speed.
@export var chase_speed: float = 32.0

## How much damage the slime will cause upon player collision.
@export var attack_damage: float = 30.0

## The suffix used for idle animations in the [AnimatedSprite2D].
@export var idle_animation_suffix: StringName = "_idle"

## The area to monitor for player chase interactions.
@onready var chase_area : Area2D = $ChaseArea

const DEAD_BODY = preload("uid://dg6vd4w76xk55")

# Physics process variables

## The target position the slime will move towards.[br]
## Updated in [method _physics_process].
var target_position := position

## The angle that the target position is located at from the current position.[br]
## Set when the random position is regenerated in [method _generate_random_position]
var target_angle_vector: Vector2

## Whether the target position is to the left of the current position.
## Used to check when the slime has reached the [member target_position].[br]
## Updated in [method _physics_process].
var target_position_on_left := false


## The player node.[br]
## Set when the player enters the [member chase_area], but resets when
## the slime goes off screen.
var player_node: CharacterBody2D = null


# Controls the delay between idle movement cycles
@onready var _idle_movement_timer: Timer = $IdleMovementTimer

# Sprite
@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Connect to the chase Area2D if it was set
func _ready() -> void:
	$DamageComponent.health = 100

# NOTE: When the slime moves too far off screen, movement calculations are
# automatically stopped by the VisibleOnScreenEnabler2D
# Move and animate the slime
func _physics_process(_delta: float) -> void:
	# If the idle movement timer is running, skip movement calculations
	if not _idle_movement_timer.is_stopped():
		return
	
	if player_node != null:
		# Move towards the player (chase sequence)
		velocity = chase_speed * (player_node.position - position).normalized()
	else:
		# Move randomly (idle movement)
		
		# Calculate distance from the target position
		var offset_x := target_position.x - position.x
		
		# Check if the target position was passed
		if (
				# Moved from right to left
				target_position_on_left and offset_x >= 0.0
				
				# Moved from left to right
				or not target_position_on_left and offset_x <= 0.0
		):
			# Regenerate target position and use idle animation
			_idle_movement_timer.start()
			if _animated_sprite_2d.animation != "death":
				_animated_sprite_2d.play(_animated_sprite_2d.animation + idle_animation_suffix)
		
		# Update speed
		velocity = idle_speed * target_angle_vector
	
	# Finalize movement
	move_and_slide()

## Generates a [Vector2] in a random direction from the current position within
## the specified distance bounds (inclusive).
func _generate_random_position(dist_min: float, dist_max: float) -> Vector2:
	# Vector in random direction
	var rand_dir := Vector2.from_angle(randf_range(0, 2*PI))
	target_angle_vector = rand_dir
	
	# Random distance within bounds, multiply vector
	var rand_dist := randf_range(dist_min, dist_max)
	rand_dir *= rand_dist
	
	# Return vector offset by position
	return position + rand_dir


# Idle movement cycle
func _on_idle_movement_timer_timeout() -> void:
	target_position = _generate_random_position(15.0, 25.0)
	target_position_on_left = (target_position.x - position.x <= 0.0)
	
	# Set new animation
	if abs(target_angle_vector.x) >= abs(target_angle_vector.y):
		# More horizontal movement than vertical movement
		if target_angle_vector.x >= 0:
			# Moving right
			_animated_sprite_2d.play("right")
		else:
			# Moving left
			_animated_sprite_2d.play("left")
	else:
		# More vertical movement than horizontal movement
		if target_angle_vector.y >= 0:
			# Moving down (positive y)
			_animated_sprite_2d.play("down")
		else:
			# Moving up (negative y)
			_animated_sprite_2d.play("up")


# Reset player variable on screen exit
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	player_node = null

func damaged_sequence():
	#damage animation
	pass

func suicide():
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	var dead_body = DEAD_BODY.instantiate()
	dead_body.type = "slime_dead"
	dead_body.set_type()
	get_parent().add_child(dead_body)
	dead_body.position = position
	dead_body.name = "Dead" + name
	queue_free()


func _on_target_area_body_entered(body):
	if body is CharacterBody2D and body.is_in_group("Player"):
		player_node = body
		# Stop idle movement
		_idle_movement_timer.stop()

func _on_chase_area_body_exited(body):
	if body is CharacterBody2D and body.is_in_group("Player"):
		# Start idle movement
		_idle_movement_timer.start()
		player_node = null
