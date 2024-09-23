class_name Vector2i
extends Reference

var x: int
var y: int

func _init(x: int, y: int):
	self.x = x
	self.y = y

func vector2() -> Vector2:
	return Vector2(x, y)
