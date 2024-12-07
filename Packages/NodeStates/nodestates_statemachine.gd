class_name StateMachine
extends NodeStates

@export var animation_player : AnimationEventPlayer
@export var current_state : StateNode

func _ready() -> void:
	if current_state != null:
		current_state.enter_state(true)
