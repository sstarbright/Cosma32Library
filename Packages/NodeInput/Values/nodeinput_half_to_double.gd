class_name InputHalfToDouble
extends Reference

var x_pos
var x_neg
var y_pos
var y_neg
var previous = Vector2.ZERO
var current = Vector2.ZERO
var changed = false
var name = ""
var parent

func start(_parent_node):
	pass

func vector():
	x_pos.vector()
	x_neg.vector()
	y_pos.vector()
	y_neg.vector()
	
	previous = current
	current = (x_pos.current + x_neg.current + y_pos.current + y_neg.current).normalized()
	changed = x_pos.changed || x_neg.changed || y_pos.changed || y_neg.changed
