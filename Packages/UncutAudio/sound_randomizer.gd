class_name SoundRandomizer
extends Node

@export var sounds # (Array, AudioStreamWAV)

func get_sound():
	return sounds[AudioManager.random.randi_range(0, sounds.size()-1)]
