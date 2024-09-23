class_name Vector2i
extends Reference

var x: int
var y: int

func _init(initial_x: int, initial_y: int):
	x = initial_x
	y = initial_y

func vector2() -> Vector2:
	return Vector2(x, y)
