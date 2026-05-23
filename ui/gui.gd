extends Control

class_name GUI

@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fade.color.a = 1.0
	$Fade/RestartButton.modulate.a = 0.0
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
	$AnimationPlayer.play("game_over_title")
	await animation_player.animation_finished
	$Fade/RestartButton.visible = true
	$AnimationPlayer.play("restart_button_fade_in")
	await animation_player.animation_finished
	$Fade/RestartButton.disabled = false
	#get_tree().paused = true
	


func _on_restart_button_pressed() -> void:
	SFXManager.create_audio(SFXSettings.SFX_LABEL.ButtonPress)
	
	Gamestate.restart_sequence()
