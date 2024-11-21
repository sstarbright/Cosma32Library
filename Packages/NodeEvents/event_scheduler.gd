class_name EventScheduler
extends Node

#Speed scale at which to process events.
@export var timing_speed = 1.0

var elapsed_time = 0.0
var events = Array()
var event_position = 0
var current_event_position = 0
##The event index to skip to.
@export var skip_to = 0
##Is the schedule current playing?
@export var playing = true

func _ready():
	var _added = child_entered_tree.connect(Callable(self, "child_added"))
	var _removed = child_exiting_tree.connect(Callable(self, "child_removed"))
	var children = get_children()
	for child in children:
		if child is ScheduledEvent || child is TimedEvent:
			events.append(child)
		else:
			child.queue_free()
	if events.size() > 0:
		events[0].event_start()

func _process(delta):
	elapsed_time += delta
	if playing:
		current_event_position = event_position
		skip_to = event_position
		while current_event_position < events.size():
			events[current_event_position].event_update(delta*timing_speed)
			if events[current_event_position].wait_for_me:
				if events[current_event_position].complete:
					skip(current_event_position + 1)
				break
			current_event_position += 1
		event_position = skip_to

func child_added(child):
	if child is ScheduledEvent || child is TimedEvent:
		events.insert(child.get_index(), child)
		event_position = event_position + 1 if child.get_index() < event_position else event_position
	else:
		child.queue_free()

func child_removed(child):
	if child is ScheduledEvent || child is TimedEvent:
		events.remove(child.get_index())
		event_position = event_position - 1 if child.get_index() < event_position else event_position

func reset():
	skip_to = 0

func skip(pos):
	skip_to = pos
	if pos < events.size():
		events[pos].event_start()

func pause():
	playing = false

func play():
	playing = true
