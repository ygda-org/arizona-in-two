extends CharacterBody2D

@export var direction: Vector2 = Vector2.ZERO

@export var damage: int = 10

@export var originalPosition: Vector2 = Vector2.ZERO

var distance: float = 150.0

var spawnChance: float = 0.33

var speed = 0.5

func _ready() -> void:
	velocity = speed * direction

func _physics_process(delta: float) -> void:
	var currDistance := originalPosition.distance_to(position)
	if currDistance >= distance:
		if randf() < spawnChance:
			var temp = load("res://enemies/tumbleweed/tumbleweed_enemy.tscn").instantiate()
			temp.position = position
			get_parent().add_child(temp)
		suicide()
	move_and_slide()

func damaged_sequence():
	pass

func suicide():
	queue_free()
