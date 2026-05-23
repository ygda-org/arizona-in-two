extends Area2D

class_name Bullet

@export var damage = 1 #Bullet's damage
@export var effects = ["fire","ice"] #Bullet's effects

## set this variable on instantiate if special effects
var bullet_attribute = "Normal"

@export var direction = Vector2() # bullet direction of travel

@export var bulletBounce = false

#Certain node(s) should be excluded from bullet detection
@export var excluded_nodes : Array[Node2D]

var speed = 128 #The speed of the bullet

var bounceCount = 0
var maxBounceCount = 2

func _ready() -> void:
	SFXManager.create_audio(SFXSettings.SFX_LABEL.Gunshot)
	$Sprite2D.rotation = direction.angle()
	if Gamestate.player_selected_bullet == 1:
		$Sprite2D.texture = load("uid://b0hh83564wuyl")
		bullet_attribute = "Silver"
	elif Gamestate.player_selected_bullet == 2:
		$Sprite2D.texture = load("uid://du5vgx11eg5vh")
		bullet_attribute = "Ice"
	elif Gamestate.player_selected_bullet == 3:
		$Sprite2D.texture = load("uid://clwyj6ncrsr3g")
		bullet_attribute = "Fire"
	
func _physics_process(delta):
	position += speed * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	call_deferred("queue_free")

func _on_body_entered(body: Node2D) -> void:
	#Check for excluded Nodes
	#only works as a for loop? DEBUG later
	if body in excluded_nodes:
		return
	var damage_component : DamageComponent = body.find_child("DamageComponent")
	if damage_component:
		damage_component.accept_bullet_(self)
		suicide()
		return
	if bulletBounce == true:
		var angle: int = int(rad_to_deg(body.get_angle_to(direction)))
		if angle == 135:
			if $CollisionShape2D/Left.is_colliding():
				direction = Vector2(-direction.x, direction.y)
			elif $CollisionShape2D/Down.is_colliding():
				direction = Vector2(direction.x, -direction.y)
		elif angle == -135:
			if $CollisionShape2D/Left.is_colliding():
				direction = Vector2(-direction.x, direction.y)
			elif $CollisionShape2D/Up.is_colliding():
				direction = Vector2(direction.x, -direction.y)
		elif angle == 45:
			if $CollisionShape2D/Right.is_colliding():
				direction = Vector2(-direction.x, direction.y)
			elif $CollisionShape2D/Down.is_colliding():
				direction = Vector2(direction.x, -direction.y)
		elif angle == -45:
			if $CollisionShape2D/Right.is_colliding():
				direction = Vector2(-direction.x, direction.y)
			elif $CollisionShape2D/Up.is_colliding():
				direction = Vector2(direction.x, -direction.y)
		elif abs(angle) == 90 or angle == 180 or angle == 0:
			var dirConversions = {0: Vector2(-1, 0), 180: Vector2(1, 0), -90: Vector2(0,1), 90: Vector2(0,-1)}
			direction = dirConversions[angle]
		if maxBounceCount < bounceCount:
			call_deferred("queue_free")
		await get_tree().create_timer(0.05).timeout

func suicide():
	#explosions or smth if needed
	queue_free()
