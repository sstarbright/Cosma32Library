class_name SoundRandomizer
extends Node

export(Array, AudioStreamSample) var sounds

func get_sound():
	return sounds[AudioManager.random.randi_range(0, sounds.size()-1)]
