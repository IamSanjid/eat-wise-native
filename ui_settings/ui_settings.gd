extends Node

const MIN_UI_SCALE_FACTOR := 1.00
const MAX_UI_SCALE_FACTOR := 3.00

# `get_size_override()` will return a valid size only if the stretch mode is `2d`.
# Otherwise, the viewport size is used directly.
@export var viewport_base_size: Vector2 :
	get():
		return get_viewport().size
		
@export var price_unit: String :
	get():
		return "tk"

@export var properties := Properties.new():
	set(value):
		# TODO: Save? and Update?
		properties = value

@export var ui_scale_factor := 1.0:
	set(value):
		value = clampf(
			snappedf(value, 0.01),
			MIN_UI_SCALE_FACTOR,
			MAX_UI_SCALE_FACTOR
		)

		if ui_scale_factor == value:
			return

		ui_scale_factor = value
		# TODO: Save settings..

		if not is_node_ready():
			await self.ready  # while loading from disk

		get_window().content_scale_factor = ui_scale_factor

		await get_tree().process_frame

		var minimum_content_size := Vector2.ZERO
		for child in get_window().get_children():
			if child is Control:
				minimum_content_size = minimum_content_size.max(
					child.get_combined_minimum_size()
				)

		get_window().min_size = minimum_content_size * ui_scale_factor

func get_theme() -> Theme:
	return get_window().theme

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().theme = ResourceLoader.load(
		"res://themes/default.tres",
		"",
		ResourceLoader.CACHE_MODE_IGNORE
	)
