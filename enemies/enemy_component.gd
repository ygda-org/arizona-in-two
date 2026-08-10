extends Node2D

class_name EnemyComponent

signal damaged
signal dead

@export var health : float = 150
@export var knockback_strength : float = 100.0
@export var hit_flash_enabled : bool = true
@onready var parent : CharacterBody2D = get_parent()
@onready var shader_mat : ShaderMaterial = parent.get_node("Anim").material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func process_bullet(bullet: Bullet):
	var bullet_dmg = bullet.damage #exported damage
	var effects = bullet.bullet_attribute #exported effect string
	#do certain actions based on the effects here
	if effects == "Silver":
		pass # knockback
	
	parent.velocity = bullet.direction * knockback_strength
	
	health -= bullet_dmg #take damage
	if(health <= 0):
		dead.emit()
	else:
		if hit_flash_enabled:
			shader_mat.set_shader_parameter("color", Color(1.0,1.0,1.0,1.0))
			shader_mat.set_shader_parameter("enabled", true)
			$FlashTimer.start()
		damaged.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_flash_timer_timeout() -> void:
	shader_mat.set_shader_parameter("enabled", false)
