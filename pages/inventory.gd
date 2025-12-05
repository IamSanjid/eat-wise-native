extends Control

@export var item: PackedScene

var categories: Array[String] = [ "All Categories" ]

var current_data = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item == null:
		printerr("An item scene must be set")
	%HTTPRequest.request_completed.connect(_on_request_completed)
	%SearchByCategory.item_selected.connect(func(_index): _update_container())
	%SearchName.text_changed.connect(func(_new_text): _update_container())
	%RefreshButton.pressed.connect(refresh)

func _enter_tree() -> void:
	if current_data == null:
		call_deferred("refresh")
	
func _update_filter_options():
	%SearchByCategory.clear()
	for i in range(0, categories.size()):
		%SearchByCategory.add_item(categories[i], i)
		
	%SearchByCategory.select(0)

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	%RefreshButton.disabled = false
	if result != HTTPRequest.RESULT_SUCCESS:
		%LabelLoading.text = "Failed to fetch result, error code: " + str(result) + ", response code: " + str(response_code)
		return
		
	var response_text = body.get_string_from_utf8()
	var json = JSON.parse_string(response_text)
	if not json is Array:
		%LabelLoading.text = "Got invalid response: " + response_text.substr(0, min(10, response_text.length())) + "..."
		return
	
	current_data = json
	_update_container();
	_update_filter_options()
	
	%LabelLoading.visible = false

func _update_container():
	for child in %ItemContainer.get_children():
		%ItemContainer.remove_child(child)

	categories = [ "All Categories" ]

	var categories_set: Dictionary[String, bool] = { categories[0]: true }
	for value in current_data:
		var inventory_item = item.instantiate().duplicate() as InventoryItem
		inventory_item.update_by_json(value)
		if !categories_set.has(inventory_item.category.to_lower()):
			categories.append(inventory_item.category.to_lower())
			categories_set[inventory_item.category.to_lower()] = true
		%ItemContainer.add_child(inventory_item)

	if %SearchByCategory.selected > 0:
		Filter.filter_by_string_property(%ItemContainer,
			"category",
			categories[%SearchByCategory.selected],
			Filter.FilterStringFlags.CONTAINS | Filter.FilterStringFlags.CASE_INSENSITIVE)

	if %SearchName.text.length() > 0:
		Filter.filter_by_string_property(%ItemContainer,
			"name",
			%SearchName.text,
			Filter.FilterStringFlags.BEGINS_WITH | Filter.FilterStringFlags.ENDS_WITH | Filter.FilterStringFlags.CASE_INSENSITIVE)

func refresh():
	%SearchName.text = ""
	%LabelLoading.visible = true
	%RefreshButton.disabled = true

	for child in %ItemContainer.get_children():
		%ItemContainer.remove_child(child)
	categories = [ "All Categories" ]
	_update_filter_options()
	%HTTPRequest.request(Controller.API_FOOD_ITEMS)
