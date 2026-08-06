extends Sprite2D

func _ready():
	GameState.loaded_camera_spawns.append(self.global_position)
