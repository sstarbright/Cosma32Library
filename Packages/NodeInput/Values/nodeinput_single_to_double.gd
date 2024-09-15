class_name InputSingleToDouble
extends Reference

var x
var y
var previous = Vector2.ZERO
var current = Vector2.ZERO
var changed = false
var name = ""

func start(_parent_node):
	pass

func vector():
	x.vector()
	y.vector()
	
	previous = current
	current = x.current + y.current
	changed = x.changed || y.changed
