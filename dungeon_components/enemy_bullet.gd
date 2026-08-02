extends Area2D

var damage = 0
var velocity = Vector2(1,0)

func _ready():
	rotation = velocity.angle()

func _on_body_entered(body):
	body.find_child("DamageComponent").take_damage(damage)
	suicide()

func _process(delta):
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func suicide():
	queue_free()
