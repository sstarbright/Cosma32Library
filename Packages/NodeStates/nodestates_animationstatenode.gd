class_name AnimationStateNode
extends StateNode

@export var time_scale := 1.0
@export var animation_name := ""
@export var state_sync : AnimationStateSync

var event_track = -1
var target_animation : Animation
var event_indices = []

func _ready() -> void:
	target_animation = get_parent().animation_player.get_animation(animation_name)
	event_track = target_animation.add_track(Animation.TYPE_METHOD)
	target_animation.track_set_path(event_track, get_node(get_parent().animation_player.root_node).get_path_to(get_parent().animation_player))
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

func enter_state(entered_on_start := false) -> bool:
	if entered_on_start:
		setup_event_track()
		get_parent().animation_player.play(animation_name, -1, time_scale)
	return super.enter_state(entered_on_start)

func leave_state(cancel_events := false) -> bool:
	if super.leave_state():
		if event_indices.size() > 0:
			clear_event_track(cancel_events)
		return true
	else:
		return false

func clear_event_track(cancel_events := false):
	for state_index in range(event_indices.size()):
		target_animation.track_remove_key(event_track, 0)
	for child in get_children():
		if child is AnimationStateEvent:
				child.state_index = -1
				if cancel_events:
					child.cancel()
	event_indices.clear()

func play(transition_time = -1.0):
	get_parent().animation_player.play(animation_name, transition_time, time_scale)

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

func get_animation_position() -> float:
	if is_active():
		return get_parent().animation_player.current_animation_position
	else:
		return 0.0
