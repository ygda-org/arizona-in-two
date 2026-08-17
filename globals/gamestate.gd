extends Node

var master_volume = 0.5
var music_volume = 0.75
var ambience_volume = 0.5
var sfx_volume = 0.5

var player_health: int = 100
var player_max_health: int = 100
var player_selected_bullet = 0 # 0 normal, 1 silver, 2 fire, 3 ice
var player_max_bullet_strength = 3
@onready var player : Player
var bullet_time_obtained = true # should be default false
var bullet_time = false

var player_bonus_damage: int = 0

var persist_generic_upgrades = []

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
var ice_dungeon_boss_cleared = false

var player_can_take_damage : bool = true

signal player_dead

const MENU = preload("uid://85alntk1uqvy")

var total_elapsed_time = 0

var loaded_camera_spawns = []

var from_menu: bool

func _ready():
	change_bus_volume("Master", GameState.master_volume)
	change_bus_volume("Music", GameState.music_volume)
	change_bus_volume("SFX", GameState.sfx_volume)
	change_bus_volume("Ambience", GameState.ambience_volume)

func _process(delta):
	total_elapsed_time += delta

func reset():
	player_health = player_max_health

func restart_sequence():
	#ZoneManager.modified_zones.clear()
	SceneSwitcher.switch_scene(MENU, "")
	player_health = player_max_health

func damage_player(amount : int):
	
	player_can_take_damage = false
	
	if player_health <= amount:
		player_health = 0
		player_dead.emit()
		return
	
	player_health -= amount
	
	SFX.play(SFX.Id.HIT_SOUND)
	if player:
		player.call_deferred("set_iframe_shader", true)
		player.iFrameTimer.start()
		

func player_selected_bullet_cycle(num: int):
	player_selected_bullet = posmod(player_selected_bullet+num, player_max_bullet_strength+1)
	if player_selected_bullet == 1:
		player_selected_bullet = posmod(player_selected_bullet+num, player_max_bullet_strength+1)
		
func change_bus_volume(bus, linear_value):
	if bus == "Master":
		GameState.master_volume = linear_value
	if bus == "Music":
		GameState.music_volume = linear_value
	if bus == "SFX":
		GameState.sfx_volume = linear_value
	if bus == "Ambience":
		GameState.ambience_volume = linear_value
	
	var db_value = linear_to_db(linear_value)
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, db_value)
