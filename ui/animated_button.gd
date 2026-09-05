extends Button

const STRETCH_SCALE = Vector2(1.1,1.1)
const REST_SCALE = Vector2(1.0,1.0)
const SQUISH_SCALE = Vector2(0.9,0.9)

const STRETCH_TIME = 0.1
const ROTATION_AMOUNT = deg_to_rad(2)
const SQUISH_TIME = 0.1

const TOTAL_PRESSED_WAIT = SQUISH_TIME + SQUISH_TIME

var _tween : Tween = null

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.pressed.connect(_on_pressed)

func _on_pressed():
	_restart_tween()
	_tween.tween_property(self, "offset_transform_rotation", 0, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.parallel().tween_property(self, "offset_transform_scale", SQUISH_SCALE, SQUISH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.tween_interval(0.1)
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, SQUISH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	SFX.play(SFX.Id.BUTTON_CLICK)

func _on_mouse_entered():
	_restart_tween()
	_tween.tween_property(self, "offset_transform_scale", STRETCH_SCALE, STRETCH_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	_tween.parallel().tween_property(self, "offset_transform_rotation", ROTATION_AMOUNT, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	SFX.play(SFX.Id.BUTTON_HOVER)

func _on_mouse_exited():
	_restart_tween()
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0, STRETCH_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	SFX.play(SFX.Id.BUTTON_HOVER, false, 0.0, 0.5)

func _restart_tween():
	if _tween:
		_tween.kill()
	_tween = create_tween()
