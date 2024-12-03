class_name AnimationStateNode
extends StateNode

@export var time_scale := 1.0
@export var animation_player : AnimationPlayer
@export var animation_name := ""

var event_track = -1
var target_animation : Animation
var event_indices = []

func _ready() -> void:
	target_animation = animation_player.get_animation(animation_name)
	event_track = target_animation.add_track(Animation.TYPE_METHOD)
	target_animation.track_set_path(event_track, get_node(animation_player.root_node).get_path_to(animation_player))
	super._ready()

func setup_event_track():
	if event_indices.size() > 0:
		clear_event_track()
	var is_events = false
	for child in get_children():
		if child is AnimationStateEvent:
			child.state_index = event_indices.size()
			event_indices.append(target_animation.track_insert_key(event_track, child.time, {
				"method": "emit_event_signal",
				"args": [child.event_called, true]
			}))
			is_events = true
	if !is_events:
		clear_event_track()

func enter_state(entered_on_ready := false) -> bool:
	if entered_on_ready:
		setup_event_track()
		animation_player.play(animation_name, -1, time_scale)
	return super.enter_state(entered_on_ready)

func leave_state() -> bool:
	if super.leave_state():
		if event_indices.size() > 0:
			clear_event_track()
		return true
	else:
		return false

func clear_event_track():
	for state_index in range(event_indices.size()):
		target_animation.track_remove_key(event_track, 0)
	for child in get_children():
		if child is AnimationStateEvent:
				child.state_index = -1
	event_indices.clear()

func play(transition_time = -1.0):
	animation_player.play(animation_name, transition_time, time_scale)

func disable_event(event : AnimationStateEvent):
	if event.state_index >= 0 && event.state_index < event_indices.size():
		target_animation.track_set_key_value(event_track, event_indices[event.state_index], {
			"method": "emit_event_signal",
			"args": [event.event_called, false]
		})

func enable_event(event : AnimationStateEvent):
	if event.state_index >= 0 && event.state_index < event_indices.size():
		target_animation.track_set_key_value(event_track, event_indices[event.state_index], {
			"method": "emit_event_signal",
			"args": [event.event_called, true]
		})
