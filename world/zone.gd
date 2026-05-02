class_name Zone
extends Node2D
## A node containing a section, or zone, of a single world which can connect to
## other zones of the world.
##
## Zones are changed by the [ZoneManager] node by changing the whole scene in
## [method ZoneManager.change_zone].[br][br]
##
## The direction on the "filename" and "area" properties indicate which
## direction the scene change goes in. For example, the [member left_zone_filename]
## property indicates that the specified zone is to the left of this zone.[br][br]
##
## "Filename" properties indicate what the new scene is called.[br]
## "Area" properties are used to create interaction areas for scene changes,
## and their [CollisionShape2D] node should be named "CollisionShape2D".


## Base file path to where the zones are located.
@export var ZONE_PATH: StringName = "res://world/"


# These directions identify which direction the scene change goes in
# The filename variable is used to set what new scene should be loaded
# The area variable is used to identify when an interaction has occurred

## The filename of for the zone to the [b]left[/b] of this zone.
@export var left_zone_filename: StringName
## The interaction area for the zone to the [b]left[/b] of this zone.
@export var left_zone_area: Area2D
## Left spawnpoint variable. Coordinate
@export var left_spawn_point : Vector2

## The filename for the zone [b]above[/b] this zone.
@export var up_zone_filename: StringName
## The interaction area for the zone [b]above[/b] this zone.
@export var up_zone_area: Area2D
## Up spawnpoint variable. Coordinate
@export var up_spawn_point : Vector2

## The filename of for the zone to the [b]right[/b] of this zone.
@export var right_zone_filename: StringName
## The interaction area for the zone to the [b]right[/b] of this zone.
@export var right_zone_area: Area2D
## Right spawnpoint variable. Coordinate
@export var right_spawn_point : Vector2

## The filename for the zone [b]below[/b] this zone.
@export var down_zone_filename: StringName
## The interaction area for the zone [b]below[/b] this zone.
@export var down_zone_area: Area2D
## Down spawnpoint variable. Coordinate
@export var down_spawn_point : Vector2


# The background TileMapLayer.
# Used to update the camera limits in adjust_camera_limits().
@onready var _tile_map_layer: TileMapLayer = $BackgroundTileMapLayer

const GUI_SCENE = preload("uid://bh2vqcphc387j")
var gui : GUI = GUI_SCENE.instantiate()
# Connect to the interaction areas
func _ready() -> void:
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	canvas_layer.add_child(gui)
	start_up()

func start_up():
	await get_tree().create_timer(0.1).timeout
	if left_zone_area != null:
		_connect_location(left_zone_area, ZoneManager.ZONE_DIRECTION.LEFT)
	
	if up_zone_area != null:
		_connect_location(up_zone_area, ZoneManager.ZONE_DIRECTION.UP)
	
	if right_zone_area != null:
		_connect_location(right_zone_area, ZoneManager.ZONE_DIRECTION.RIGHT)
	
	if down_zone_area != null:
		_connect_location(down_zone_area, ZoneManager.ZONE_DIRECTION.DOWN)
	
	gui.fade_in()
	await gui.animation_player.animation_finished

## Updates the limits on the passed in [Camera2D] to match this zone's area.
func adjust_camera_limits(camera: Camera2D) -> void:
	camera.zoom = Vector2(3,3)
	
	if _tile_map_layer == null:
		push_warning('BackgroundTileMapLayer not found')
		return
	# Get the tile size
	var tile_size := _tile_map_layer.tile_set.tile_size
	
	# Get the map rectangle
	var map_rect := _tile_map_layer.get_used_rect()
	
	# The minimum x and y values will be at the top-left corner
	var x_min := (map_rect.position.x * tile_size.x)
	var y_min := (map_rect.position.y * tile_size.y)
	
	# The maximum x and y values are offset by the rectangle's size
	# to get the bottom-right corner
	var x_max := x_min + (map_rect.size.x * tile_size.x)
	var y_max := y_min + (map_rect.size.y * tile_size.y)
	
	# Set the limits
	camera.limit_left = x_min
	camera.limit_top = y_min
	camera.limit_right = x_max
	camera.limit_bottom = y_max


# Connects an Area2D's body_entered signal to the _change_zone() function
func _connect_location(location: Area2D, direction: ZoneManager.ZONE_DIRECTION) -> void:
	# Connect to the body_entered signal
	if not location.body_entered.is_connected(_on_area_2d_body_entered):
		location.body_entered.connect(_on_area_2d_body_entered.bind(direction))

func _disconnect_location(location: Area2D, direction: ZoneManager.ZONE_DIRECTION) -> void:
	location.body_entered.disconnect(_on_area_2d_body_entered)

## Handles [signal Area2D.body_entered] signals and calls [method ZoneManager.change_zone].
## When calling [method ZoneManager.change_zone], a [PackedScene] version
## of the next zone specified by [param direction] is used.
func _on_area_2d_body_entered(body: Node2D, direction: ZoneManager.ZONE_DIRECTION) -> void:
	# Skip non-player interactions
	# NOTE: "Player" was the original Scene Group (now a Global Group) while "player" was the new Global Group
	# To ensure prior compatibility, both groups are now checked
	if not body.is_in_group("Player") and not body.is_in_group("player"):
		return
	gui.fade_out()
	await gui.animation_player.animation_finished
	body.position = Vector2.ZERO
	# Get the filename for the next scene (Zone)
	var new_zone_filename : StringName = ""
	var new_spawnpoint : Vector2 = Vector2.ZERO
	
	if left_zone_area != null:
		_disconnect_location(left_zone_area, ZoneManager.ZONE_DIRECTION.LEFT)
	
	if up_zone_area != null:
		_disconnect_location(up_zone_area, ZoneManager.ZONE_DIRECTION.UP)
	
	if right_zone_area != null:
		_disconnect_location(right_zone_area, ZoneManager.ZONE_DIRECTION.RIGHT)
	
	if down_zone_area != null:
		_disconnect_location(down_zone_area, ZoneManager.ZONE_DIRECTION.DOWN)
	
	match direction:
		# Match the direction (ignore NONE)
		ZoneManager.ZONE_DIRECTION.LEFT:
			new_zone_filename = left_zone_filename
			new_spawnpoint = left_spawn_point
		ZoneManager.ZONE_DIRECTION.UP:
			new_zone_filename = up_zone_filename
			new_spawnpoint = up_spawn_point
		ZoneManager.ZONE_DIRECTION.RIGHT:
			new_zone_filename = right_zone_filename
			new_spawnpoint = right_spawn_point
		ZoneManager.ZONE_DIRECTION.DOWN:
			new_zone_filename = down_zone_filename
			new_spawnpoint = down_spawn_point
	
	# Load a PackedScene version of the next zone
	var new_zone_packed: PackedScene = load(ZONE_PATH + new_zone_filename + ".tscn")
	# Call the _change_zone function directly
	ZoneManager.change_zone(new_zone_packed, direction, new_spawnpoint)
