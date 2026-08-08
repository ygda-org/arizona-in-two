extends StaticBody2D

@export var persist_break: bool = true

func _ready():
	if persist_break:
		$BulletDestructionComponent.persist_break_id = str(hash(self))
	else:
		$BulletDestructionComponent.persist_break_id = ""
