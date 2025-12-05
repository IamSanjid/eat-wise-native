extends Node

enum CssVectorType {
	## Invalid type
	INVALID,
	## Size in Pixel
	PIXEL,
	## % of Viewport Width
	VW,
	## % of Viewport Height
	VH,
	## % of the relative parent
	PERCENTAGE,
}

class CssVector2:
	var x_type: CssVectorType = CssVectorType.PIXEL
	var y_type: CssVectorType = CssVectorType.PIXEL
	var x := 0.0
	var y := 0.0
	func _init(_x: float, _y: float, _xtype := CssVectorType.PIXEL, _ytype := CssVectorType.PIXEL):
		self.x = _x
		self.y = _y
		self.x_type = _xtype
		self.y_type = _ytype
		
	func _to_string() -> String:
		return "{ x: " + str(x) + CssVectorType.keys()[x_type] + ", y: " + str(y) + CssVectorType.keys()[y_type] + " }"
	
	func to_vec(parent: Control = null) -> Vector2:
		var viewport_size = UISettings.viewport_base_size
		return Vector2(
			ParseCssParts._apply_to_comp(x, x_type, Vector2(1, 0), viewport_size, parent),
			ParseCssParts._apply_to_comp(y, y_type, Vector2(0, 1), viewport_size, parent)
		)
	
	static func from(value: String) -> CssVector2:
		var split := value.split(",", false, 2)
		if split.size() < 2:
			printerr("Cannot convert '" + value + "' to CssVector2")
			return CssVector2.new(0, 0)
		var x_comp = ParseCssParts._parse_vector_comp_and_type(split[0].strip_escapes().strip_edges().to_lower())
		var y_comp = ParseCssParts._parse_vector_comp_and_type(split[1].strip_escapes().strip_edges().to_lower())
		return CssVector2.new(x_comp.value, y_comp.value, x_comp.type, y_comp.type)
	
func _parse_vector_comp_and_type(value: String) -> Dictionary:
	var number_part := ""
	var unit_part := ""
	for i in range(0, value.length()):
		var c := value[i]
		if c == '.': number_part += '.'
		elif c == ' ': continue
		elif c.is_valid_int(): number_part += c
		else: unit_part += c
	
	return {
		'value': number_part.to_float(),
		'type': _unit_to_css_vector_comp_type(unit_part)
	}
	
func _unit_to_css_vector_comp_type(value: String) -> CssVectorType:
	match value:
		'px', 'pixel', '', ' ': return CssVectorType.PIXEL
		'vw': return CssVectorType.VW
		'vh': return CssVectorType.VH
		'%': return CssVectorType.PERCENTAGE
		_: return CssVectorType.INVALID

func _apply_to_comp(value: float, type: CssVectorType, dir: Vector2, viewport_size: Vector2, parent: Control = null):
	var new_value = value
	match type:
		CssVectorType.VW:
			new_value = viewport_size.x * (value / 100.0)
		CssVectorType.VH:
			new_value = viewport_size.y * (value / 100.0)
		CssVectorType.PERCENTAGE:
			if parent == null:
				printerr("Parent is null but the required type needs the relative parent")
				return value
			new_value = (parent.size * dir).length()
			
	return new_value
