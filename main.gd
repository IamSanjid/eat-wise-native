extends Control

@onready var nav_container: NavigationContainer = %NavigationContainer

func _ready() -> void:
	Controller.pages = nav_container.pages
	Controller.nav_container = nav_container
	%NavHomeIcon.connect("pressed", self._move_to_main_page)
	
func _move_to_main_page():
	Controller.nav_container.reset()
