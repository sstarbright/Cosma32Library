class_name Follow3Das2D
extends Control

@export var node_to_follow : Node3D

func _ready() -> void:
	position = node_to_follow.get_viewport().get_camera_3d().unproject_position(node_to_follow.global_position)

func _physics_process(_delta) -> void:
	position = node_to_follow.get_viewport().get_camera_3d().unproject_position(node_to_follow.global_position)
