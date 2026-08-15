extends CharacterBody2D

class_name Player

@export var animated_sprite_2d : AnimatedSprite2D

@export var shot_speed_multiplier = 1

@export var speedMulti = 1.0
var speed: int = 95
const deceleration: int = 700
const acceleration: int = 50

const BULLET = preload("uid://c7uqco4biuu2g")
var shot_cooldown_seconds = 0.35
var time_since_last_shot = 0

var bounce_powerup = false

var shotgun_powerup = false

var damage : float = 50.0

const SHOTGUN_SPREAD = PI/4 # spread per shot

@onready var iFrameTimer : Timer = $IFrameTimer
@onready var camera = $Camera
@onready var particles = $CPUParticles2D

var ice = false

var on_sand : bool = false
var on_snow : bool = false
var on_grass : bool = false
var on_magma : bool = false


func _ready():
	GameState.player = self
	
	animated_sprite_2d = $AnimatedSprite2D
	
	GameState.bullet_time = false

func _physics_process(delta: float) -> void:
	if SceneSwitcher.anim.is_playing():
		return
	# Iframe ducttape
	if GameState.player_can_take_damage == false and $IFrameTimer.time_left == 0:
		$IFrameTimer.start()
	
	# Particles only show up when moving
	particles.emitting = velocity.length() > 0
	
	movement(delta) # Movement function (Others can be added below)
	
	shoot(delta)
	
	if ice == true:
		speedMulti = 0.5
	elif ice == false:
		speedMulti = 1
	
	move_and_slide()

func movement(delta):
	if Input.is_action_just_pressed("BulletTime") and $BulletTimeDur.is_stopped() and GameState.bullet_time_obtained and $BulletTimeCD.is_stopped():
		$BulletTimeDur.start()
		GameState.bullet_time = true
	
	# Maps input to correct vector for velocity
	var inputDir: Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	if inputDir:
		play_footsteps()
		
		# Slowly increases the speed
		velocity = lerp(velocity, speed * speedMulti * inputDir, delta * acceleration)
		if Input.is_action_pressed("DEBUGRUN"):
			velocity *= 3
		# Finds which direction in the X Axis
		var horizontal := "" 
		if inputDir.x < 0: horizontal = "l"
		if inputDir.x > 0: horizontal = "r"
		
		# Finds which direction in the Y Axis
		var vertical := ""
		if inputDir.y < 0: vertical = "u"
		if inputDir.y > 0: vertical = "d"
		
		# Logic for Animated Sprites
		
		if not $AnimatedSprite2D.animation.ends_with("gun") or not $AnimatedSprite2D.is_playing():
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
						$AnimatedSprite2D.play("front_walk")
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
		if not $AnimatedSprite2D.animation.ends_with("gun") or not $AnimatedSprite2D.is_playing():
			if $AnimatedSprite2D.animation.begins_with("right"):
				$AnimatedSprite2D.play("front_idle")
			elif $AnimatedSprite2D.animation.begins_with("left"):
				$AnimatedSprite2D.play("front_idle")
			elif $AnimatedSprite2D.animation.begins_with("front"):
				$AnimatedSprite2D.play("front_idle")
			elif $AnimatedSprite2D.animation.begins_with("back"):
				$AnimatedSprite2D.play("back_idle")
		velocity = velocity.move_toward(Vector2.ZERO, delta*deceleration)

func shoot(delta):
	# check for bullet cycling
	if Input.is_action_just_pressed("CycleBullet"):
		GameState.player_selected_bullet_cycle(1)
	if Input.is_action_just_pressed("CycleBulletBackwards"):
		GameState.player_selected_bullet_cycle(-1)
	
	# Check if can shoot
	if time_since_last_shot < shot_cooldown_seconds * (1.0/shot_speed_multiplier):
		time_since_last_shot += delta
		return
	
	# Maps input to correct vector for velocity
	var inputDir: Vector2 = Input.get_vector("ShootLeft", "ShootRight", "ShootUp", "ShootDown")
	
	if inputDir:
		time_since_last_shot = 0
		
		if inputDir.x < 0:
			$AnimatedSprite2D.play("left_gun")
		if inputDir.x > 0:
			$AnimatedSprite2D.play("right_gun")
		if inputDir.y < 0:
			$AnimatedSprite2D.play("back_gun")
		if inputDir.y > 0:
			$AnimatedSprite2D.play("front_gun")
			
		var bullet1 : Bullet = BULLET.instantiate()
		# sets bullet direction
		bullet1.damage = damage + GameState.player_bonus_damage
		bullet1.direction = inputDir
		bullet1.position = position
		bullet1.excluded_nodes = [self]
		if bounce_powerup:
			bullet1.bulletBounce = true
		get_parent().add_child(bullet1)#find_child("Bullets", false).add_child(bullet1)
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

func set_spawn_position(pos):
	global_position = pos
	$Camera.global_position = pos

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

func apply_fire():
	$AnimatedSprite2D.modulate = Color(1.0, 0.306, 0.445, 1.0)
	for i in 3:
		GameState.damage_player(5)
		await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.modulate = Color(1.0,1.0,1.0)

func apply_ice():
	ice = true
	$AnimatedSprite2D.modulate = Color(0.227,0.356,1.0)
	await get_tree().create_timer(2).timeout
	$AnimatedSprite2D.modulate = Color(1.0,1.0,1.0)
	ice = false

func _on_i_frame_timer_timeout() -> void:
	if GameState.player_health == 0:
		return
	GameState.player_can_take_damage = true
	set_iframe_shader(false)


func _on_bullet_time_dur_timeout() -> void:
	GameState.bullet_time = false
	$BulletTimeCD.start()

#region footsteps

func _on_sand_footsteps_body_entered(_body):
	on_sand = true
	
func _on_sand_footsteps_body_exited(_body):
	on_sand = false

func _on_grass_footsteps_body_entered(_body):
	on_grass = true


func _on_grass_footsteps_body_exited(_body):
	on_grass = false


func _on_magma_footsteps_body_entered(_body):
	on_magma = true


func _on_magma_footsteps_body_exited(_body):
	on_magma = false


func _on_snow_footsteps_body_entered(_body):
	on_snow = true


func _on_snow_footsteps_body_exited(_body):
	on_snow = false

func play_footsteps():
	if on_sand:
		SFX.play(SFX.Id.GRASS_STEP)
	if on_grass:
		SFX.play(SFX.Id.GRASS_STEP)
	if on_snow:
		SFX.play(SFX.Id.SNOW_FOOTSTEPS)
	if on_magma:
		SFX.play(SFX.Id.MAGMA_STEP)

#endregion
