class_name IgnoreParentRotation
extends Node3D

@export var keep_rotation : Vector3
@export var keep_scale := Vector3(1.0,1.0,1.0)

func _process(_delta:float):
	global_rotation_degrees = keep_rotation
	global_scale(keep_scale)
