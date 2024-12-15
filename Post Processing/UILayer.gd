class_name UILayer
extends Node

func _ready():
	pass

func add_element(new_element: PackedScene):
	add_child(new_element.instantiate())

func remove_element(element_name: String):
	var element_to_remove = get_node_or_null(element_name)
	if element_to_remove != null:
		element_to_remove.queue_free()
