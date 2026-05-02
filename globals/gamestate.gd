extends Node

var player_health: int = 1000

@onready var player : Player

var player_can_take_damage : bool = true

func reset():
	player_health = 1000

func damage_player(amount : int):
	player_can_take_damage = false
	player_health -= amount
	player.set_iframe_shader(true)
	player.iFrameTimer.start()
