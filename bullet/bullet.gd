extends Area2D

@export var damage = 1 #Bullet's damage
@export var effects = ["fire","ice"] #Bullet's effects

@export var x_direction = 0
@export var y_direction = 0

var speed = 128 #The speed of the bullet

func _physics_process(delta):
	position.x += speed * x_direction * delta
	position.y += speed * y_direction * delta
