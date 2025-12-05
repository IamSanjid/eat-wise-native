extends Button

@export var scale_grow := Vector2(0.05, 0.05)
@export var animation_duration := 0.05

var original_size := Vector2.ZERO
var original_scale := Vector2.ZERO
var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_mouse_entered() -> void:
	if not tween:
		original_size = size
		original_scale = scale
		pivot_offset = Vector2(original_size.x / 2, original_size.y / 2)
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", original_scale + scale_grow, animation_duration)\
		.set_trans(Tween.TRANS_BOUNCE)

func _on_mouse_exited() -> void:
	if not tween:
		original_size = size
		original_scale = scale
		pivot_offset = Vector2(original_size.x / 2, original_size.y / 2)
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", original_scale, animation_duration)\
		.set_trans(Tween.TRANS_BOUNCE)
