class_name Parent2Dto3D
extends Control

func _physics_process(_delta) -> void:
	global_position = get_viewport().get_camera_3d().unproject_position((get_parent() as Node3D).global_position)

func show_control():
	global_position = get_viewport().get_camera_3d().unproject_position((get_parent() as Node3D).global_position)
	show()
