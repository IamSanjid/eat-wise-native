extends GridContainer
class_name AutoGridContainer

@export var max_columns := 4
@export var item_width := -1

var last_area_size := Vector2.ZERO
var last_item_width := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = max_columns
	child_order_changed.connect(_on_child_order_changed)

func _on_item_rect_changed() -> void:
	force_update()

func _on_child_order_changed() -> void:
	force_update()

func force_update() -> void:
	var area_size = self.get_parent_area_size()
	var max_item_width = item_width
	if max_item_width <= 0:
		for child in get_children():
			if child is Control:
				var control = child as Control
				max_item_width = max(control.size.x, max_item_width)
	if last_area_size == area_size and last_item_width == max_item_width:
		return
	last_area_size = area_size

	var cur_columns := max_columns
	while cur_columns > 1 and area_size.x / max_item_width <= cur_columns:
		cur_columns -= 1
	columns = cur_columns
