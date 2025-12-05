extends MarginContainer
class_name NavigationContainer

@export var start_page := ""
@export var pages: Dictionary[String, PackedScene]

# TODO: If some performance happens when so many pages are pushed, we can try to remove "duplicate" page instances
class Page:
	var name: String
	var control: Control
	func _init(_name: String, _control: Control):
		self.name = _name
		self.control = _control

var page_stack: Array[Page] = []
var current_page := ""
@onready var page_continer := %PageContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if pages.size() > 0 && pages.has(start_page):
		reset()

func _on_b_go_back_pressed() -> void:
	pop_page()

func reset():
	clear_page_stack()
	current_page = start_page
	page_stack.push_back(Page.new(current_page, pages[current_page].instantiate()))
	page_continer.add_child(page_stack[page_stack.size() - 1].control)
	%BGoBack.visible = false	

func clear_page_stack():
	page_stack.clear()
	for child in page_continer.get_children():
		page_continer.remove_child(child)
	current_page = ""

func pop_page() -> void:
	if page_stack.size() <= 1:
		return
	page_stack.pop_back()
	_reinstantiate_last_page()

func push_page(page_name: String) -> void:
	if current_page == page_name or not pages.has(page_name):
		return
	page_stack.push_back(Page.new(page_name, pages[page_name].instantiate()))
	_reinstantiate_last_page()

func _reinstantiate_last_page():
	var page = page_stack[page_stack.size() - 1]
	current_page = page.name
	page_continer.remove_child(page_continer.get_child(page_continer.get_child_count() - 1))
	page_continer.add_child(page.control)
	
	if page_stack.size() > 1:
		%BGoBack.visible = true
	else:
		%BGoBack.visible = false
