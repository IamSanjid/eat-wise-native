extends Control
class_name InventoryItem

@export var id := 0
@export var category := ""
@export var expiration_time_days := 0
@export var cost_per_unit := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("gui_input", self._on_item_gui_input)

func _on_item_gui_input(event) -> void:
	if not event is InputEventMouseButton and not event is InputEventScreenTouch:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$Item/MarginContainer/VBoxContainer/DetailsContainer.visible = !$Item/MarginContainer/VBoxContainer/DetailsContainer.visible
	elif event is InputEventScreenTouch and event.pressed:
		$Item/MarginContainer/VBoxContainer/DetailsContainer.visible = !$Item/MarginContainer/VBoxContainer/DetailsContainer.visible

func update_by_json(json):
	id = int(json["id"])
	name = json["name"]
	category = json["category"]
	expiration_time_days = int(json["expirationTimeDays"])
	cost_per_unit = float(json["costPerUnit"])

	$Item/MarginContainer/VBoxContainer/Name.text = name
	$Item/MarginContainer/VBoxContainer/Badges/CategoryBadge.update_text(category)
	$Item/MarginContainer/VBoxContainer/Badges/ExpTimeBadge.update_text(str(expiration_time_days) + " days")
	$Item/MarginContainer/VBoxContainer/Badges/PriceBadge.update_text(str(cost_per_unit) + " " + UISettings.price_unit)
	$Item/MarginContainer/VBoxContainer/DetailsContainer/GridContainer/HBoxContainer/CategoryDetails.text = category
	$Item/MarginContainer/VBoxContainer/DetailsContainer/GridContainer/HBoxContainer3/ExpTimeDetails.text = str(expiration_time_days) + " days"
	$Item/MarginContainer/VBoxContainer/DetailsContainer/GridContainer/HBoxContainer2/PriceDetails.text = str(cost_per_unit) + " " + UISettings.price_unit
