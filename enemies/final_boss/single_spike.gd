extends Area2D

var fade_out: bool = true

var damage = 15

var timer_modifier : float = 0
var timer_variation : bool = false

func _ready():
	$CollisionShape2D.disabled = true
	
	$Timer.wait_time += timer_modifier
	if timer_variation:
		$Timer.wait_time += randf_range(-0.25,0.25)
	$Timer.start()

func _on_anim_animation_finished():
	$CollisionShape2D.disabled = false


func _on_timer_timeout():
	if not fade_out:
		return
	var tween = get_tree().create_tween()
	tween.tween_property($Anim, "modulate", Color(1.0,1.0,1.0,0.0), 1.0)
	tween.tween_callback(queue_free)


func _on_body_entered(_body):
	GameState.damage_player(damage)
