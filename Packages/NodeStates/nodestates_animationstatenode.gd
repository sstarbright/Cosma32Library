class_name AnimationStateNode
extends StateNode

@export var time_scale := 1.0
@export var animation_player : AnimationPlayer
@export var animation_name := ""

func enter_state(entered_on_ready := false) -> bool:
	if entered_on_ready:
		animation_player.play(animation_name, -1, time_scale)
	return super.enter_state(entered_on_ready)

func play(transition_time = -1.0):
	animation_player.play(animation_name, transition_time, time_scale)
