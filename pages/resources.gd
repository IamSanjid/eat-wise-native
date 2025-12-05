extends VBoxContainer

@export var resource: PackedScene

var categories: Array[String] = [ "All Categories" ]
var types: Array[String] = [ "All types" ]

var current_data = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if resource == null:
		printerr("A resource scene must be set")
	
	%HTTPRequest.request_completed.connect(_on_request_completed)
	%SeachByCategory.item_selected.connect(_on_selected_category)
	%SearchByType.item_selected.connect(_on_selected_type)
	%SearchTitle.text_changed.connect(_on_search_title_changed)
	%RefreshButton.pressed.connect(refresh)

func _enter_tree() -> void:
	if current_data == null:
		call_deferred("refresh")

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
	_update_resources_container()
	_update_filter_options()

	%LabelLoading.visible = false

func _on_selected_category(_index: int):
	_update_resources_container()
	
func _on_selected_type(_index: int):
	_update_resources_container()
	
func _on_search_title_changed(_new_text: String):
	_update_resources_container()

func _update_filter_options():
	%SeachByCategory.clear()
	%SearchByType.clear()
	for i in range(0, categories.size()):
		%SeachByCategory.add_item(categories[i], i)
	for i in range(0, types.size()):
		%SearchByType.add_item(types[i], i)
		
	%SeachByCategory.select(0)
	%SearchByType.select(0)

func _update_resources_container():
	for child in %ResourcesContainer.get_children():
		%ResourcesContainer.remove_child(child)

	categories = [ "All Categories" ]
	types = [ "All types" ]

	var categories_set: Dictionary[String, bool] = { categories[0]: true }
	var types_set: Dictionary[String, bool] = { types[0]: true }
	for value in current_data:
		var resource_item = resource.instantiate().duplicate() as ResourceItem
		resource_item.update_by_json(value)
		if !categories_set.has(resource_item.category.to_lower()):
			categories.append(resource_item.category.to_lower())
			categories_set[resource_item.category.to_lower()] = true
		if !types_set.has(resource_item.type.to_lower()):
			types.append(resource_item.type)
			types_set[resource_item.type.to_lower()] = true
		%ResourcesContainer.add_child(resource_item)

	if %SeachByCategory.selected > 0:
		Filter.filter_by_string_property(%ResourcesContainer,
			"category",
			categories[%SeachByCategory.selected],
			Filter.FilterStringFlags.CONTAINS | Filter.FilterStringFlags.CASE_INSENSITIVE)

	if %SearchByType.selected > 0:
		Filter.filter_by_string_property(%ResourcesContainer,
			"type",
			types[%SearchByType.selected],
			Filter.FilterStringFlags.CONTAINS | Filter.FilterStringFlags.CASE_INSENSITIVE)

	if %SearchTitle.text.length() > 0:
		Filter.filter_by_string_property(%ResourcesContainer,
			"title",
			%SearchTitle.text,
			Filter.FilterStringFlags.BEGINS_WITH | Filter.FilterStringFlags.ENDS_WITH | Filter.FilterStringFlags.BY_WORDS | Filter.FilterStringFlags.CASE_INSENSITIVE)

func refresh():
	%SearchTitle.text = ""
	%RefreshButton.disabled = true
	%LabelLoading.visible = true
	for child in %ResourcesContainer.get_children():
		%ResourcesContainer.remove_child(child)
	categories = [ "All Categories" ]
	types = [ "All types" ]
	_update_filter_options()
	%HTTPRequest.request(Controller.API_RESOURCES_MANAGE)
