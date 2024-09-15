class_name InputHalfToSingle
extends Reference

var pos
var neg
var previous = 0.0
var current = 0.0
var changed = false
var name = ""

func start(_parent_node):
	pass

func float():
	pos.float()
	neg.float()
	
	previous = current
	current = pos.current + neg.current
	changed = pos.changed || neg.changed
