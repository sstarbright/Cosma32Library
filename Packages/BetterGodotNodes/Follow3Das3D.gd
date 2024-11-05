extends Node3D

@export var node_to_follow : Node3D
@export var follow_position := true
@export var follow_rotation := false
@export var relative_to_source_view := false

signal visibility_changed_with_state(new_state: bool)

func _ready() -> void:
	if node_to_follow != null:
		if relative_to_source_view:
			global_position = get_viewport().get_camera_3d().project_position(node_to_follow.get_viewport().get_camera_3d().unproject_position(node_to_follow.global_position), get_viewport().get_camera_3d().position.z)
		else:
			global_position = node_to_follow.global_position
		if follow_rotation:
			global_rotation = node_to_follow.global_rotation
	else:
		visible = false
	connect("visibility_changed", Callable(self, "vis_changed"))

func _physics_process(_delta) -> void:
	update_position()

func set_node_to_follow(new_follow_node: Node3D):
	node_to_follow = new_follow_node
	update_position()
	visible = true

func update_position():
	if node_to_follow != null:
		if relative_to_source_view:
			global_position = get_viewport().get_camera_3d().project_position(node_to_follow.get_viewport().get_camera_3d().unproject_position(node_to_follow.global_position), get_viewport().get_camera_3d().position.z)
		else:
			global_position = node_to_follow.global_position
		if follow_rotation:
			global_rotation = node_to_follow.global_rotation

func vis_changed():
	emit_signal("visibility_changed_with_state", visible)
