extends Node

var player_health: int = 1000

@onready var player : Player

var player_can_take_damage : bool = true

signal player_dead

func reset():
	player_health = 1000

func damage_player(amount : int):
	player_can_take_damage = false
	
	if player_health <= amount:
		player_health = 0
		player_dead.emit()
		return
	
	player_health -= amount
	player.set_iframe_shader(true)
	player.iFrameTimer.start()
