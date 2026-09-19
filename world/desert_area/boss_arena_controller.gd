extends Node2D

func _ready():
	if GameState.final_boss_cleared:
		$TileMapLayer.queue_free()
	
func boss_clear():
	$TileMapLayer.queue_free()
