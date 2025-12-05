extends Control

func _on_goto_register_meta_clicked(_meta: Variant) -> void:
	Controller.nav_container.push_page("register")
