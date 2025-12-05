extends Button

@export var hover_offset := Vector2(0, -5)
@export var animation_duration := 0.05

var original_position: Vector2
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position
	add_theme_font_override("font", get_window().theme.get_font(UISettings.properties.default_button.font, ""))
	add_theme_font_size_override("font_size", UISettings.properties.default_button.font_size)

func _on_mouse_entered() -> void:
	if not tween:
		original_position = position
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", original_position + hover_offset, animation_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if not tween:
		original_position = position
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", original_position, animation_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
