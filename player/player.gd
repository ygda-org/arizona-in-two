extends CharacterBody2D

class_name Player

@export var shot_speed_multiplier = 1

@export var speedMulti = 1.0
var speed: int = 70
const deceleration: int = 10
const acceleration: int = 50

const BULLET = preload("uid://c7uqco4biuu2g")
var shot_cooldown_seconds = 0.35
var time_since_last_shot = 0

var bounce_powerup = false

var shotgun_powerup = false

var damage : float = 5.0

const SHOTGUN_SPREAD = PI/4 # spread per shot

@onready var iFrameTimer : Timer = $IFrameTimer

func _physics_process(delta: float) -> void:
	
	# Iframe ducttape
	if Gamestate.player_can_take_damage == false and $IFrameTimer.time_left == 0:
		$IFrameTimer.start()
	
	movement(delta) # Movement function (Others can be added below)
	
	shoot(delta)
	
	move_and_slide()

func movement(delta):
	# Maps input to correct vector for velocity
	var inputDir: Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	
	if inputDir:
		#if $AnimatedSprite2D.animation_finished:
			#SFXManager.create_audio(SFXSettings.SFX_LABEL.GrassStep)
		
		# Slowly increases the speed
		velocity = lerp(velocity, speed * speedMulti * inputDir, delta * acceleration)
		
		# Finds which direction in the X Axis
		var horizontal := "" 
		if inputDir.x < 0: horizontal = "l"
		if inputDir.x > 0: horizontal = "r"
		
		# Finds which direction in the Y Axis
		var vertical := ""
		if inputDir.y < 0: vertical = "u"
		if inputDir.y > 0: vertical = "d"
		
		# Logic for Animated Sprites
		if horizontal == "l":
			match vertical:
				"u":
					# Left + Up
					$AnimatedSprite2D.play("left_walk")
				"d":
					# Left + Down
					$AnimatedSprite2D.play("left_walk")
				"":
					# Left
					$AnimatedSprite2D.play("left_walk")
		elif horizontal == "r":
			match vertical:
				"u":
					# Right + Up
					$AnimatedSprite2D.play("right_walk")
				"d":
					# Right + Down
					$AnimatedSprite2D.play("right_walk")
				"":
					# Right
					$AnimatedSprite2D.play("right_walk")
		else:
			match vertical:
				"u":
					# Up
					$AnimatedSprite2D.play("back_walk")
				"d":
					# Down
					$AnimatedSprite2D.play("front_walk")
		
	else:
		# Slowly decreases the speed of the player
		$AnimatedSprite2D.play("idle")
		velocity = lerp(velocity, Vector2(0, 0), delta * deceleration)

func shoot(delta):
	# check for bullet cycling
	if Input.is_action_just_pressed("CycleBullet"):
		Gamestate.player_selected_bullet_cycle()
	
	# Check if can shoot
	if time_since_last_shot < shot_cooldown_seconds * (1.0/shot_speed_multiplier):
		time_since_last_shot += delta
		return
	
	# Maps input to correct vector for velocity
	var inputDir: Vector2 = Input.get_vector("ShootLeft", "ShootRight", "ShootUp", "ShootDown")
	
	if inputDir:
		
		time_since_last_shot = 0
		
		var bullet1 : Bullet = BULLET.instantiate()
		# sets bullet direction
		bullet1.damage = damage
		bullet1.direction = inputDir
		bullet1.position = position
		bullet1.excluded_nodes = [self]
		if bounce_powerup:
			bullet1.bulletBounce = true
		get_parent().find_child("Bullets", false).add_child(bullet1)
		bullet1.global_position = $BulletSpawnLoc.global_position
	
		if shotgun_powerup:
			var bullet2 : Bullet = BULLET.instantiate()
			var bullet3 : Bullet = BULLET.instantiate()
			bullet2.damage = damage
			bullet3.damage = damage
			bullet2.direction = inputDir.rotated(SHOTGUN_SPREAD)
			bullet3.direction = inputDir.rotated(-SHOTGUN_SPREAD)
			bullet2.position = position
			bullet3.position = position
			bullet2.excluded_nodes = [self]
			bullet3.excluded_nodes = [self]
			if bounce_powerup:
				bullet2.bulletBounce = true
				bullet3.bulletBounce = true
			get_parent().find_child("Bullets", false).add_child(bullet2)
			get_parent().find_child("Bullets", false).add_child(bullet3)
		
		time_since_last_shot += delta

func gain_powerup(power_name):
	if power_name == "shotgun":
		$ShotgunPowerTimer.start()
		shotgun_powerup = true
	if power_name == "bounces":
		$BouncesPowerTimer.start()
		bounce_powerup = true

func set_iframe_shader(val : bool):
	$AnimatedSprite2D.material.set_shader_parameter("isFlash", val)

func _on_shotgun_power_timer_timeout():
	shotgun_powerup = false

func _on_bounces_power_timer_timeout() -> void:
	bounce_powerup = false

func suicide():
	queue_free()

func damaged_sequence():
	pass

func _on_i_frame_timer_timeout() -> void:
	if Gamestate.player_health == 0:
		return
	Gamestate.player_can_take_damage = true
	set_iframe_shader(false)
