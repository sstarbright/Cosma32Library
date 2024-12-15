class_name AddUIStateEvent
extends AnimationStateEvent

@export var ui_prefab : PackedScene
@export var position_reference : Node3D

func _ready():
	event_called.connect(Callable(self, "addUiPrefab"))

func addUiPrefab() -> Node:
	var new_ui = ui_prefab.instantiate()
	new_ui.position = position_reference.get_viewport().get_camera_3d().unproject_position(position_reference.global_position)
	PostProcessEngine.post_process_scene.ui_layer.add_child(new_ui)
	return new_ui
