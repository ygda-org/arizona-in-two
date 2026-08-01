extends Area2D

var damage = 0
var velocity = Vector2(1,0)

func _ready():
	rotation = velocity.angle()

func _on_body_entered(body):
	body.find_child("DamageComponent").take_damage(damage)
	queue_free()

func _process(delta):
	position += velocity * delta
