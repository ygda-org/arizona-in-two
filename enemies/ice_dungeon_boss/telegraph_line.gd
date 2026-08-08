extends Sprite2D


func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.7)
	tween.tween_callback(queue_free)
