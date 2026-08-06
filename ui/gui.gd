extends Control

class_name GUI

@onready var animation_player : AnimationPlayer = $AnimationPlayer

var indicators = ["Normal", "Silver", "Ice", "Fire"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fade.color.a = 1.0
	$Fade/RestartButton.modulate.a = 0.0
	GameState.player_dead.connect(game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$TextureRect/Label.text = "Health: " + str(GameState.player_health)
	set_bullet(indicators[GameState.player_selected_bullet])
	

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

func set_bullet(bullet_name):
	for n in $BulletIndicator.get_children():
		n.visible = false
	$BulletIndicator/Current.visible = true
	$BulletIndicator.get_node(bullet_name).visible = true

func _on_restart_button_pressed() -> void:
	SFX.play(SFX.Labels.BUTTON_CLICK)
	
	GameState.restart_sequence()

func _on_restart_button_mouse_entered():
	SFX.play(SFX.Labels.BUTTON_HOVER)
