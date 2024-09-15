class_name AutoAnimationPlayer
extends AnimationPlayer

export var start_animation = ""
export var start_blend_amount = -1.0
export var start_speed = 1.0
export var start_from_end = false

func _ready():
	play_animation(start_animation)

func play_animation(animation_name = "", speed = 1.0):
	play(animation_name, -1.0, speed)

func change_position(position = 0.0):
	current_animation_position = position

func stop_animation():
	stop()
