extends Control

class_name GUI

@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fade.color.a = 1.0
	Gamestate.player_dead.connect(game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TextureRect/Label.text = "Health: " + str(Gamestate.player_health)

func fade_in():
	$AnimationPlayer.play("fade_in")

func fade_out():
	$AnimationPlayer.play("fade_out")

func game_over():
	fade_out()
	await animation_player.animation_finished
	$Fade/LoseLabel.visible = true
	get_tree().paused = true
	
