extends CharacterBody2D

var speed: int = Gamestate.playerSpeed
const deceleration := 10
const acceleration := 0.9

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	movement(delta) # Movement function (Others can be added below)
	
	
	move_and_slide()

func movement(delta):
	# Maps input to correct vector for velocity
	var inputDir: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	
	if inputDir:
		# Slowly increases the speed
		velocity = lerp(velocity, speed * inputDir, delta * acceleration)
		
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
					pass # Animated sprite for Left + Up
				"d":
					pass # Animated sprite for Left + Down
				"":
					pass # Animated sprite for Left ONLY
		elif horizontal == "r":
			match vertical:
				"u":
					pass # Animated sprite for Right + Up
				"d":
					pass # Animated sprite for Right + Down
				"":
					pass # Animated sprite for Right ONLY
		else:
			match vertical:
				"u":
					pass # Animated sprite for Up ONLY
				"d":
					pass # Animated sprite for Down ONLY
		
	else:
		# Slowly decreases the speed of the player
		velocity = lerp(velocity, Vector2(0, 0), delta * deceleration)
