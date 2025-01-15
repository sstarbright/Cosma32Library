class_name AnimationStateSync
extends Resource

@export_node_path("AnimationStateNode") var sync_state : NodePath
var sync_state_node : AnimationStateNode
var enabled := false

func _init() -> void:
	if resource_local_to_scene:
		enabled = true
		sync_state_node = get_local_scene().get_node(sync_state) as StateNode
	else:
		print("ERROR: Sync only works if Local to Scene.")

func sync_position() -> float:
	if enabled:
		return sync_state_node.get_animation_position()
	else:
		return 0.0
