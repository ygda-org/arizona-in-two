extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.bullet_time_obtained:
		queue_free()


func _on_body_entered(body):
	GameState.bullet_time_obtained = true
	queue_free()
