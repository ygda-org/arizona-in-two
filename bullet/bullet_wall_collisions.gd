extends Area2D

func _on_body_entered(_body):
	SFX.play(SFX.Labels.BUTTON_HOVER, false, 10, 0)
	get_parent().suicide()
