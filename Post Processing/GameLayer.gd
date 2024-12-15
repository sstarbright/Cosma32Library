class_name GameLayer
extends Node

@export var initial_scene : PackedScene
var current_scene : Node

func _ready():
	if initial_scene != null:
		current_scene = initial_scene.instantiate()
		add_child.call_deferred(current_scene)

func switch_scene(new_scene: PackedScene):
	if current_scene != null:
		current_scene.queue_free()
		await current_scene.tree_exited
	current_scene = new_scene.instantiate()
	add_child(current_scene)

func close_scene() -> bool:
	if current_scene != null:
		current_scene.queue_free()
		await current_scene.tree_exited
		return true
	return true
