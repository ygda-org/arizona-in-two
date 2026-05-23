extends Node

var player_health: int = 100
var player_selected_bullet = 0 # 0 normal, 1 silver, 2 ice, 3 fire
var player_max_bullet_strength = 3
@onready var player : Player

var player_can_take_damage : bool = true

signal player_dead

const MENU = preload("uid://85alntk1uqvy")

var total_elapsed_time = 0

func _process(delta):
	total_elapsed_time += delta

func reset():
	player_health = 100

func restart_sequence():
	ZoneManager.modified_zones.clear()
	SceneSwitcher.switch_scene(MENU)
	player_health = 100

func damage_player(amount : int):
	
	player_can_take_damage = false
	
	if player_health <= amount:
		player_health = 0
		player_dead.emit()
		return
	
	player_health -= amount
	
	SFXManager.create_audio(SFXSettings.SFX_LABEL.HitSound)
	
	player.set_iframe_shader(true)
	player.iFrameTimer.start()

func player_selected_bullet_cycle(num: int):
	player_selected_bullet = (player_selected_bullet+num)%(player_max_bullet_strength+1)
