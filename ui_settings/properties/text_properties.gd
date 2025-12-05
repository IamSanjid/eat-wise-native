extends Resource
class_name TextProperties

@export var font := "regular"
@export var font_size := 64

func _init(_font = "regular", _font_size = 64):
	self.font = _font
	self.font_size = _font_size
