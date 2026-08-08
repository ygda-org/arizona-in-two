extends Node

var master_volume = 0.5
var music_volume = 0.5
var ambience_volume = 0.5
var sfx_volume = 0.5

var player_health: int = 100
var player_selected_bullet = 0 # 0 normal, 1 silver, 2 fire, 3 ice
var player_max_bullet_strength = 1
@onready var player : Player
var bullet_time_obtained = true # should be default false
var bullet_time = false

var player_keys = 0
var player_big_keys = 0
var persist_unlocked_doors = []
var persist_keys_obtained = []
enum RoomClearSignals {
	NONE,
	ENEMIES,
	PUZZLE
}
signal enemies_cleared
signal puzzle_cleared
@onready var room_clear_signal_array = [null, enemies_cleared, puzzle_cleared]

var persist_break_ids = []

var player_can_take_damage : bool = true

signal player_dead

const MENU = preload("uid://85alntk1uqvy")

var total_elapsed_time = 0

var loaded_camera_spawns = []

func _process(delta):
	total_elapsed_time += delta

func reset():
	player_health = 100

func restart_sequence():
	#ZoneManager.modified_zones.clear()
	SceneSwitcher.switch_scene(MENU, "")
	player_health = 100

func damage_player(amount : int):
	
	player_can_take_damage = false
	
	if player_health <= amount:
		player_health = 0
		player_dead.emit()
		return
	
	player_health -= amount
	
	SFX.play(SFX.Labels.HIT_SOUND)
	if player:
		player.call_deferred("set_iframe_shader", true)
		player.iFrameTimer.start()

func player_selected_bullet_cycle(num: int):
	player_selected_bullet = posmod(player_selected_bullet+num, player_max_bullet_strength+1)
