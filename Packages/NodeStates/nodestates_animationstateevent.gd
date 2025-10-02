class_name AnimationStateEvent
extends NodeStates

signal event_called

@export var time := 0.0
var state_index = -1

func enable():
	get_parent().enable_event(self)

func disable():
	get_parent().disable_event(self)

func cancel():
	pass

func _exit_tree():
	get_parent().disable_event(self)

func call_event():
	event_called.emit()
