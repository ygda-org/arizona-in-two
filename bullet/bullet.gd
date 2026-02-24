extends Area2D

@export var damage = 1 #Bullet's damage
@export var effects = ["fire","ice"] #Bullet's effects
var speed = 128 #The speed of the bullet

func _physics_process(delta):
	#Calculates how much to change x-coordinate
	position.x += cos(rotation) * speed * delta
	#Calculates how much to change y-coordinate
	position.y += sin(rotation) * speed * delta 
