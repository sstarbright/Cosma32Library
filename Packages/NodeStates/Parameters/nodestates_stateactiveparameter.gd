class_name StateActiveParameter
extends StateParameter

@export_node_path("StateNode") var dependant_state : NodePath
var dependant_state_node : StateNode
var enabled := false

func _init() -> void:
	if resource_local_to_scene:
		if !dependant_state.is_empty():
			enabled = true
			dependant_state_node = get_local_scene().get_node(dependant_state) as StateNode
		else:
			print("ERROR: No Dependant StateNode selected.")
	else:
		print("ERROR: Parameter only works if Local to Scene.")

func parameter_true() -> bool:
	return enabled && dependant_state_node.is_active()
