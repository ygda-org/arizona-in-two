extends Node

func switch_scene(scene_path, spawn_loc): # Accepts a String parameter
	call_deferred("switch_scene_deferred", scene_path, spawn_loc)

func switch_scene_deferred(scene_path, spawn_loc):
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await get_tree().process_frame
	var level = get_tree().current_scene
	var player = level.get_node("Player")
	player.set_spawn_position(level.find_child(spawn_loc).global_position)

func switch_scene_no_player(scene_path):
	call_deferred("switch_scene_no_player_deferred", scene_path)

func switch_scene_no_player_deferred(scene_path):
	get_tree().change_scene_to_file(scene_path)
