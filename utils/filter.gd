extends Node

enum FilterStringFlags {
	CONTAINS			= 0b000001,
	EQUALS				= 0b000010,
	BEGINS_WITH			= 0b000100,
	ENDS_WITH			= 0b001000,
	BY_WORDS			= 0b010000,
	CASE_INSENSITIVE	= 0b100000,
}

func filter_by_string_property(container: Node, prop_name: String, value: String, flags: int):
	var childs_to_remove: Array[Node] = []
	var prop_name_snake := prop_name.to_snake_case()
	var f_value := value
	if flags & FilterStringFlags.CASE_INSENSITIVE != 0:
		f_value = value.to_lower()
	for child in container.get_children():
		var prop_value: String = child.get(prop_name_snake)
		if flags & FilterStringFlags.CASE_INSENSITIVE != 0:
			prop_value = prop_value.to_lower()
		
		if flags & FilterStringFlags.BY_WORDS != 0:
			var words := prop_value.split(" ")
			var bad_words := 0
			for word in words:
				if !_check_filter_flag_and_condition(flags, FilterStringFlags.CONTAINS, word.contains(f_value))\
					and !_check_filter_flag_and_condition(flags, FilterStringFlags.EQUALS, word == f_value)\
					and !_check_filter_flag_and_condition(flags, FilterStringFlags.BEGINS_WITH, word.begins_with(f_value))\
					and !_check_filter_flag_and_condition(flags, FilterStringFlags.ENDS_WITH, word.ends_with(f_value)):
					bad_words += 1

			if bad_words == words.size():
				childs_to_remove.append(child)
		else:
			if !_check_filter_flag_and_condition(flags, FilterStringFlags.CONTAINS, prop_value.contains(f_value))\
				and !_check_filter_flag_and_condition(flags, FilterStringFlags.EQUALS, prop_value == f_value)\
				and !_check_filter_flag_and_condition(flags, FilterStringFlags.BEGINS_WITH, prop_value.begins_with(f_value))\
				and !_check_filter_flag_and_condition(flags, FilterStringFlags.ENDS_WITH, prop_value.ends_with(f_value)):
				childs_to_remove.append(child)

	for child in childs_to_remove:
		if child.get_parent() != container: continue
		container.remove_child(child)

func _check_filter_flag_and_condition(flags: int, check: FilterStringFlags, cond: bool) -> bool:
	if flags & check == 0: return false
	return cond
