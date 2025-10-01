class_name AutoPathFollow3D
extends PathFollow3D

@export var speed := 1.0
var move_follow := false

func start(start_position := 0.0):
	progress = start_position
	move_follow = true

func stop():
	move_follow = false

func _process(delta: float) -> void:
	if move_follow:
		progress += delta*speed
