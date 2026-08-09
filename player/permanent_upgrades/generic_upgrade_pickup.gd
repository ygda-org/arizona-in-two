extends Area2D
class_name GenericUpgrade

@export var persist_collect_id: String

@export var upgrade_amount: int = 10

enum UpgradeTypes {
	HEALTH,
	DAMAGE
}
@export var upgrade_type: UpgradeTypes

func _ready():
	if persist_collect_id in GameState.persist_generic_upgrades:
		queue_free()

func _on_body_entered(_body):
	GameState.persist_generic_upgrades.append(persist_collect_id)
	if upgrade_type == UpgradeTypes.HEALTH:
		GameState.player_health += upgrade_amount
		GameState.player_max_health += upgrade_amount
	elif upgrade_type == UpgradeTypes.DAMAGE:
		GameState.player_bonus_damage += upgrade_amount
