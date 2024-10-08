class_name UncutAudioListener3D
extends AudioListener3D

var target

func audio_player_process(_delta):
	if is_instance_valid(target):
		global_position = target.global_position
	else:
		queue_free()
