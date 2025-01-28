class_name StateValueParameter
extends StateParameter

@export var dependant : NodePath
var dependant_node : StateNode
@export var property_name := ""
var property_path : NodePath
var enabled := false
var comparison_value = null

func _init() -> void:
	if resource_local_to_scene:
		if !dependant.is_empty():
			enabled = true
			dependant_node = get_local_scene().get_node(dependant) as StateNode
			property_path = NodePath(property_name).get_as_property_path()
		else:
			print("ERROR: No Dependant Node selected.")
	else:
		print("ERROR: Parameter only works if Local to Scene.")

func parameter_true() -> bool:
	return enabled && dependant_node.get_indexed(property_path) == comparison_value
