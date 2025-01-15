class_name StateActiveParameter
extends StateParameter

@export_node_path("StateNode") var dependant_state : NodePath
var dependant_state_node : StateNode
var enabled := false

func _init() -> void:
	if resource_local_to_scene:
		enabled = true
		dependant_state_node = get_local_scene().get_node(dependant_state) as StateNode
	else:
		print("ERROR: Parameter only works if Local to Scene.")

func parameter_true() -> bool:
	return enabled && dependant_state_node.is_active()
