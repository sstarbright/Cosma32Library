class_name StateTransition
extends NodeStates

@export var target_state : StateNode
@export var transition_time := 0.0
@export var dependency : StateParameter

var elapsed_time := 0.0
var is_transition := false

signal transition_started
signal transition_ended

func _ready() -> void:
	if dependency == null:
		dependency = StateParameter.new()

func enter_transition(cancel_events := false) -> bool:
	if dependency.parameter_true() && target_state.dependency.parameter_true() && get_parent() is StateNode && get_parent().leave_state(cancel_events):
		transition_started.emit()
		if target_state is AnimationStateNode:
			target_state.setup_event_track()
			target_state.play(transition_time)
			if target_state.state_sync != null && target_state.state_sync.enabled:
				target_state.get_parent().animation_player.seek(target_state.state_sync.sync_position())
		if transition_time == 0.0:
			leave_transition()
		else:
			elapsed_time = 0.0
			is_transition = true
		return true
	return false

func leave_transition():
	transition_ended.emit()
	is_transition = false
	if target_state != null:
		target_state.enter_state()

func process_transition(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time >= transition_time:
		leave_transition()

func _physics_process(delta: float) -> void:
	if is_transition:
		process_transition(delta)
