class_name InputSource
extends NodeInput

enum InputValueSize {
	HALF,
	SINGLE,
	DOUBLE
}

var current = false
var previous = false
var up = false
var down = false
var changed = false
var parent

func start(parent_node):
	parent = parent_node

func size():
	return InputValueSize.DOUBLE

func bool():
	current = false

func float():
	current = 0.0

func vector():
	current = Vector2.ZERO
