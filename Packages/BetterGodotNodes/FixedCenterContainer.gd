class_name FixedCenterContainer
extends Container

var control_children = Dictionary()
var center_position = Vector2.ZERO

func _ready():
	var _connect = child_entered_tree.connect(Callable(self, "child_added"))
	var _connect1 = child_exiting_tree.connect(Callable(self, "child_removed"))

func _process(_delta):
	center_position = size/2
	for child_name in control_children.keys():
		var child = control_children[child_name]
		child.position = center_position-child.size/2

func child_added(child):
	if child is Control:
		control_children[child.name] = child
		child.position = center_position-child.size/2

func child_removed(child):
	if child is Control:
		control_children.erase(child.name)
