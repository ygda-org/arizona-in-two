extends Area2D

var fade_out: bool = true

func _ready():
	$CollisionShape2D.disabled = true

func _on_anim_animation_finished():
	$CollisionShape2D.disabled = false


func _on_timer_timeout():
	if not fade_out:
		return
	var tween = get_tree().create_tween()
	tween.tween_property($Anim, "modulate", Color(1.0,1.0,1.0,0.0), 1.0)
	tween.tween_callback(queue_free)
