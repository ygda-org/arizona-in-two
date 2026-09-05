extends Button

const STRETCH_SCALE: Vector2 = Vector2(1.1,1.1)
const REST_SCALE: Vector2 = Vector2(1.0,1.0)
const SQUISH_SCALE: Vector2 = Vector2(0.9,0.9)

const STRETCH_TIME: float = 0.1
const ROTATION_AMOUNT: float = deg_to_rad(2)
const SQUISH_TIME: float = 0.1

signal on_button_pressed_finished

var _tween : Tween = null

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	_restart_tween()
	_tween.tween_property(self, "offset_transform_rotation", 0, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.parallel().tween_property(self, "offset_transform_scale", SQUISH_SCALE, SQUISH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.tween_interval(0.1)
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, SQUISH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	SFX.play(SFX.Id.BUTTON_CLICK)
	await _tween.finished 
	on_button_pressed_finished.emit()

func _on_mouse_entered() -> void:
	_restart_tween()
	_tween.tween_property(self, "offset_transform_scale", STRETCH_SCALE, STRETCH_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	_tween.parallel().tween_property(self, "offset_transform_rotation", ROTATION_AMOUNT, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	SFX.play(SFX.Id.BUTTON_HOVER)

func _on_mouse_exited() -> void:
	_restart_tween()
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	SFX.play(SFX.Id.BUTTON_HOVER, false, 0.0, 0.5)

func _restart_tween() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
