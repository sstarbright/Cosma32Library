class_name ScheduledEvent
extends Node

##Should the schedulers stop at this event, and wait until it is complete before advancing to the next event?
@export var wait_for_me = false
##Is this event complete?
@export var complete = false
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
