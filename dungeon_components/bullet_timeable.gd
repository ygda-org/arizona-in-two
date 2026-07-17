extends Node2D


func _process(_delta):
	if GameState.bullet_time:
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	else:
		get_parent().process_mode = Node.PROCESS_MODE_INHERIT
