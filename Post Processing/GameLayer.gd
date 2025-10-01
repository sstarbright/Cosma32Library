class_name GameLayer
extends Node

@export var initial_scene : PackedScene
var current_scene : Node
var current_scene_pack : PackedScene

func _ready():
	current_scene_pack = initial_scene
	if initial_scene != null:
		current_scene = initial_scene.instantiate()
		add_child.call_deferred(current_scene)

func switch_scene(new_scene: PackedScene) -> Signal:
	current_scene_pack = new_scene
	if current_scene != null:
		current_scene.queue_free()
		await current_scene.tree_exited
	current_scene = new_scene.instantiate()
	add_child(current_scene)
	return current_scene.ready

func close_scene() -> Signal:
	current_scene.queue_free()
	return current_scene.tree_exited

func reload_scene() -> Signal:
	current_scene.queue_free()
	await current_scene.tree_exited
	current_scene = current_scene_pack.instantiate()
	add_child.call_deferred(current_scene)
	return current_scene.ready
