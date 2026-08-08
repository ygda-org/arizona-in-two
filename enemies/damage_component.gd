extends Node

class_name DamageComponent

@export var health: float = 100.0
@export var knockback_strength : float = 100.0
@export var damage: int = 10
@export var suicide_on_death: bool = false
@onready var parent : CollisionObject2D = get_parent()

var min_attack_delay_timer : Timer = null

func _ready() -> void:
	if suicide_on_death:
		assert(parent.has_method("suicide"), 'ERROR: No suicide method found')
	assert(parent.has_method("damaged_sequence"), 'ERROR: No damaged_sequence method found')
	
	for node in get_parent().get_children():
		if node.name == "MinAttackDelayTimer":
			min_attack_delay_timer = node

func accept_bullet_(bullet: Bullet):
	var damage_from_bullet = bullet.damage #exported damage
	var effects = bullet.bullet_attribute #exported effect string
	#do certain actions based on the effects here
	if effects == "Silver":
		pass # knockback
	take_damage(damage_from_bullet)

func take_damage(damage_from_player: float):
	health -= damage_from_player #take damage
	if(health <= 0):
		parent.suicide()
	parent.damaged_sequence()

func _physics_process(_delta: float) -> void:
	if knockback_strength == 0.0 and damage == 0.0:
		return
	# Check collisions
	for i in parent.get_slide_collision_count():
		var collision : KinematicCollision2D = parent.get_slide_collision(i)
		var obj := collision.get_collider()
		# Player check
		if obj is not Player:
			continue
		if not obj.is_in_group("Player") or not GameState.player_can_take_damage:
			continue
		if min_attack_delay_timer != null:
			if min_attack_delay_timer.time_left == 0:
				min_attack_delay_timer.start()
				deal_damage(collision)
		else:
			deal_damage(collision)
			
func deal_damage(collision : KinematicCollision2D):
	var obj := collision.get_collider()
	var normal := collision.get_normal()
	obj.velocity -= normal * knockback_strength
	GameState.damage_player(damage)
	if suicide_on_death:
		parent.suicide()
