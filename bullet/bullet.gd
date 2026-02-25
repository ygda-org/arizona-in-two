extends Area2D

@export var damage = 1 #Bullet's damage
@export var effects = ["fire","ice"] #Bullet's effects

@export var direction = Vector2()

var speed = 128 #The speed of the bullet

func _physics_process(delta):
	position.x += speed * direction.x * delta
	position.y += speed * direction.y * delta
