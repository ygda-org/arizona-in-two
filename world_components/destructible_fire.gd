extends StaticBody2D


@export var persist_break_id: String

func _ready():
	$BulletDestructionComponent.persist_break_id = persist_break_id
