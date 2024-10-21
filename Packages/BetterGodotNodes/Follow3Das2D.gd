class_name Follower3Das2D
extends Control

func _ready() -> void:
	position = get_viewport().get_camera_3d().unproject_position((get_parent() as Node3D).global_position)

func _physics_process(_delta) -> void:
	position = get_viewport().get_camera_3d().unproject_position((get_parent() as Node3D).global_position)
