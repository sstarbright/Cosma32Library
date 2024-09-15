class_name ScheduledEvent
extends Node

export var wait_for_me = false
export var complete = false
var started = false

func event_init():
	started = true
	event_start()

func event_update(delta):
	if !started:
		event_init()
	event_process(delta)

func event_start():
	pass

func event_process(_delta):
	pass

func finish():
	complete = true
