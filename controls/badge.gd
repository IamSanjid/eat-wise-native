extends PanelContainer
class_name Badge

@export var badge_text := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%BadgeLabel.text = badge_text

func update_text(text: String):
	badge_text = text
	%BadgeLabel.text = badge_text
