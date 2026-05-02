extends Node

class_name DamageComponent

@export var health: float = 100.0
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
		var obj := parent.get_slide_collision(i).get_collider()
		
		# Player check
		if obj is CharacterBody2D:
			if obj.is_in_group("Player"):
				print('OW')
				# TODO: Damage function
				#obj.damage(damage)
				pass
