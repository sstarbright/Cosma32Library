class_name FixedCenterContainer
extends Container

var control_children = Dictionary()
var center_position = Vector2.ZERO

func _ready():
	var _connect = connect("child_entered_tree", self, "child_added")
	var _connect1 = connect("child_exiting_tree", self, "child_removed")

func _process(_delta):
	center_position = rect_size/2
	for child_name in control_children.keys():
		var child = control_children[child_name]
		child.rect_position = center_position-child.rect_size/2

func child_added(child):
	if child is Control:
		control_children[child.name] = child
		child.rect_position = center_position-child.rect_size/2

func child_removed(child):
	if child is Control:
		control_children.erase(child.name)
