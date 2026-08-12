extends CharacterBody2D
@onready var collision_box = $"../CollisionBox"

var died = false

var player_height : float

func _ready():
	#$AnimatedSprite2D.play("default")
	$DamageComponent.health = 1.0
	player_height = 11
	
func damaged_sequence():
	pass # Hurt Animation

func suicide():
	if died == false:
		died = true
		$AnimatedSprite2D.play("death")
		$Hitbox.queue_free()
		collision_box.queue_free()

func _process(_delta):
	if global_position.y > GameState.player.position.y + player_height:
		z_index = GameState.player.z_index + 1
	elif global_position.y < GameState.player.position.y + player_height:
		z_index = GameState.player.z_index - 1
