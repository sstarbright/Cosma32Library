class_name UncutAudioListener3D
extends Listener

var target

func audio_player_process(_delta):
	if is_instance_valid(target):
		global_translation = target.global_translation
	else:
		queue_free()
