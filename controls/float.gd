extends Node
class_name Float

@export var hover_offset := Vector2(0, -5)
@export var animation_duration := 0.05

@export var control: Control
@export var hover_override: Dictionary[String, StyleBox] = {}

var original_hover_overrides: Dictionary[String, StyleBox] = {}

var original_position: Vector2
var tween: Tween

var hovered := false

func _ready() -> void:
	if control != null:
		set_control(control)

func set_control(_control: Control) -> void:
	self.control = _control
	original_position = control.position
	control.connect("mouse_entered", self._on_mouse_entered)
	control.connect("mouse_exited", self._on_mouse_exited)
	control.connect("resized", self._on_resized)

func _on_mouse_entered() -> void:
	hovered = true
	if not tween:
		original_position = control.position
	if tween and tween.is_running():
		tween.kill()
	
	for override in hover_override:
		if !original_hover_overrides.has(override):
			original_hover_overrides[override] = control.get_theme_stylebox(override)
		control.add_theme_stylebox_override(override, hover_override[override])
	
	tween = create_tween()
	tween.tween_property(control, "position", original_position + hover_offset, animation_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	hovered = false
	if not tween:
		original_position = control.position
	if tween and tween.is_running():
		tween.kill()
	
	for override in original_hover_overrides:
		control.add_theme_stylebox_override(override, original_hover_overrides[override])
	
	tween = create_tween()
	tween.tween_property(control, "position", original_position, animation_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _on_resized() -> void:
	if hovered:
		original_position = control.position - hover_offset
	else:
		original_position = control.position
