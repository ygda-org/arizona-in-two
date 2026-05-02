extends Node

class_name DamageComponent

@export var health: float = 100.0
@export var knockback_strength : float = 100.0
@export var damage: float = 10.0
@onready var parent : CharacterBody2D = get_parent()

func accept_bullet_(bullet: Bullet):
	var damage = bullet.damage #exported damage
	var effects = bullet.effects #exported effects (string array)
	#do certain actions based on the effects here
	take_damage(damage)

func take_damage(damage: float):
	health -= damage #take damage
	if(health <= 0):
		parent.suicide()
	parent.damaged_sequence()

func _physics_process(delta: float) -> void:
	# Check collisions
	for i in parent.get_slide_collision_count():
		var collision : KinematicCollision2D = parent.get_slide_collision(i)
		var obj := collision.get_collider()
		# Player check
		if obj is Player:
			if obj.is_in_group("Player") and Gamestate.player_can_take_damage:
				var normal := collision.get_normal()
				obj.velocity -= normal * knockback_strength
				Gamestate.damage_player(damage)
				pass
