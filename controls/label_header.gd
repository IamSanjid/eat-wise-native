extends Label

@export var override_font_size := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_theme_font_override("font", get_window().theme.get_font(UISettings.properties.header.font, ""))
	if override_font_size > 0:
		add_theme_font_size_override("font_size", override_font_size)
	else:
		add_theme_font_size_override("font_size", UISettings.properties.header.font_size)
