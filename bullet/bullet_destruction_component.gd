extends Node2D

enum BULLET_WEAKNESSES {
	SILVER,
	FIRE,
	ICE,
	ALL
}
const BULLET_WEAKNESS_MAP = ["Silver", "Fire", "Ice", ""]

## bullet type it is weak to. ALL will mean all bullet types
@export var weakness: BULLET_WEAKNESSES
## number of shots needed to break this component. Will not be using health
@export var num_hits_to_break: int = 1


func _on_area_entered(area):
	if "Bullet" in area.name:
		if weakness == BULLET_WEAKNESSES.ALL:
			area.play_hit_sound()
			num_hits_to_break -= 1
		elif BULLET_WEAKNESS_MAP[weakness] == area.bullet_attribute:
			area.play_hit_sound()
			num_hits_to_break -= 1
		if num_hits_to_break <= 0:
			get_parent().queue_free()
		area.queue_free()
