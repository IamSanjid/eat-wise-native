extends Resource
class_name ColorProperties

@export var background: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var border: Color = Color(0xe5e7ebff)

func _init(_background: Color = Color(1.0, 1.0, 1.0, 1.0), _border: = Color(0xe5e7ebff)):
	self.background = _background
	self.border = _border
