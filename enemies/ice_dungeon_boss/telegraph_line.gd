extends Sprite2D

var fade_time = 0.7

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), fade_time)
	tween.tween_callback(queue_free)
