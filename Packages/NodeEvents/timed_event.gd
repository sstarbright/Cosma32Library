class_name TimedEvent
extends Node

const wait_for_me = true
##How long should this event take to complete.
@export var time_to_complete = 0.0 # (float, 0.0, 86400.0)
##How much time has passed since this event became active.
@export var elapsed_time = 0.0
var complete = false
var started = false

func event_init():
	started = true
	event_start()

func event_update(delta):
	if !started:
		event_init()
	elapsed_time += delta
	complete = complete || elapsed_time > time_to_complete
	event_process(delta)

func event_start():
	pass
	
func event_process(_delta):
	pass
