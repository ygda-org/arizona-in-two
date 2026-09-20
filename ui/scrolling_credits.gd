extends Control

const SPEED = 50

func _ready():
	position.y = -200 # whatever it needs to start off screen

func _process(delta):
	position.y += SPEED * delta
