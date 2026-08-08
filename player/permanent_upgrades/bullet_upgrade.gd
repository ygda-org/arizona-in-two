extends Area2D

@export var upgrade_level: int


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.player_max_bullet_strength >= upgrade_level:
		queue_free()


func _on_body_entered(_body):
	GameState.player_max_bullet_strength = upgrade_level
	if upgrade_level == 2:
		$Sprite2D.visible = false
		set_deferred("monitoring", false)
		var gate = load("uid://bc4df4v86bpt2").instantiate()
		call_deferred("add_child", gate)
		gate.position.y += 48
	else:
		queue_free()
