extends Control
class_name ResourceItem

@export var id := 0
@export var title := ""
@export var description := ""
@export var url := ""
@export var category := ""
@export var type := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == 1)\
		or (event is InputEventScreenTouch and event.pressed):
		OS.shell_open(url)

func update_by_json(json):
	id = int(json["id"])
	title = json["title"]
	description = json["description"]
	url = json["url"]
	category = json["category"]
	type = json["type"]

	$Resource/MarginContainer/VBoxContainer/LabelTitle.text = title
	$Resource/MarginContainer/VBoxContainer/Badges/BadgeCategory.update_text(category)
	$Resource/MarginContainer/VBoxContainer/Badges/BadgeType.update_text(type)
	$Resource/MarginContainer/VBoxContainer/LabelDesc.text = description
