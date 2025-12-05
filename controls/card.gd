extends PanelContainer

@export var min_size := "92vw, 0"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style_box = get_theme_stylebox("panel") as StyleBoxFlat
	style_box.bg_color = UISettings.properties.card.background
	style_box.border_color = UISettings.properties.card.border
	add_theme_stylebox_override("panel", style_box)

	var custom_min_size = ParseCssParts.CssVector2.from(min_size).to_vec(get_parent_control())
	custom_minimum_size = custom_min_size

func _on_item_rect_changed() -> void:
	var custom_min_size = ParseCssParts.CssVector2.from(min_size).to_vec(get_parent_control())
	custom_minimum_size = custom_min_size
