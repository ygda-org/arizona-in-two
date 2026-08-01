extends Node

class_name DamageComponent

@export var health: float = 100.0
@export var knockback_strength : float = 100.0
@export var damage: float = 10.0
@export var suicide_on_death: bool = false
@onready var parent : CollisionObject2D = get_parent()

func _ready() -> void:
	if suicide_on_death:
		assert(parent.has_method("suicide"), 'ERROR: No suicide method found')
	assert(parent.has_method("damaged_sequence"), 'ERROR: No damaged_sequence method found')

func accept_bullet_(bullet: Bullet):
	var damage = bullet.damage #exported damage
	var effects = bullet.bullet_attribute #exported effect string
	#do certain actions based on the effects here
	if effects == "Silver":
		pass # knockback
	take_damage(damage)

func take_damage(damage: float):
	health -= damage #take damage
	if(health <= 0):
		parent.suicide()
	parent.damaged_sequence()

func _physics_process(delta: float) -> void:
	if knockback_strength == 0.0 and damage == 0.0:
		return
	# Check collisions
	for i in parent.get_slide_collision_count():
		var collision : KinematicCollision2D = parent.get_slide_collision(i)
		var obj := collision.get_collider()
		# Player check
		if obj is Player:
			if obj.is_in_group("Player") and GameState.player_can_take_damage:
				var normal := collision.get_normal()
				obj.velocity -= normal * knockback_strength
				GameState.damage_player(damage)
				if suicide_on_death:
					parent.suicide()
