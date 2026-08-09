extends Area2D

var damage = 10
var velocity = Vector2(1,0)

# directional bullet textures
const UP = preload("uid://ccir1ktodnkc1")
const DOWN = preload("uid://csf3r3o5mltrf")
const LEFT = preload("uid://dor30fdpo3b40")
const RIGHT = preload("uid://cl1b4y3dw4q6i")
const DIAGONAL = preload("uid://etw02yhiddfy")


func _ready():
	var rot = velocity.angle()
	$CollisionShape2D.rotation = rot
	if velocity.x > 0:
		$Sprite2D.texture = RIGHT
	elif velocity.x < 0:
		$Sprite2D.texture = LEFT
	if velocity.y > 0:
		$Sprite2D.texture = DOWN
	elif velocity.y < 0:
		$Sprite2D.texture = UP
	if velocity.x and velocity.y:
		$Sprite2D.texture = DIAGONAL
		$Sprite2D.flip_h = velocity.x > 0
		$Sprite2D.flip_v = velocity.y > 0

func _on_body_entered(body):
	GameState.damage_player(damage)
	suicide()

func _process(delta):
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func suicide():
	queue_free()
