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

func set_custom_size(new_size: Vector2):
	custom_minimum_size = new_size
	
	await get_tree().process_frame
	if !visible: return
	# re-calculate size, probably required because we're in low process mode
	visible = false
	set_deferred("visible", true)


func _on_resized() -> void:
	var custom_min_size = ParseCssParts.CssVector2.from(min_size).to_vec(get_parent_control())
	set_custom_size(custom_min_size)
