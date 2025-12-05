extends Node
class_name NavigateTo

@export var control: Control
@export var to: String
@export var on_release: bool = true

var mouse_in_bounds = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if control != null:
		set_control(control)

func set_control(_control: Control):
	self.control = _control
	self.control.connect("gui_input", self._on_gui_input)
	self.control.connect("mouse_entered", self._on_mouse_entered)
	self.control.connect("mouse_exited", self._on_mouse_exited)

func _on_mouse_entered():
	mouse_in_bounds = true

func _on_mouse_exited():
	mouse_in_bounds = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_gui_input(event: InputEvent):
	if not event is InputEventMouseButton and not event is InputEventScreenTouch:
		return
	var condition = !event.pressed if on_release else event.pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if condition and mouse_in_bounds:
			Controller.nav_container.push_page(to)
	elif event is InputEventScreenTouch and event.pressed:
		Controller.nav_container.push_page(to)
