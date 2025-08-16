class_name SoundRandomizer
extends Node

@export var sounds : Array[AudioStreamWAV]
@export_range(0.25, 2.0) var pitch_min = 1.0
@export_range(0.25, 2.0) var pitch_max = 1.0
signal new_sound(sound : AudioStreamWAV)
signal new_pitch(pitch : float)

func get_sound():
	return sounds[AudioManager.random.randi_range(0, sounds.size()-1)]

func random():
	new_sound.emit(sounds[AudioManager.random.randi_range(0, sounds.size()-1)])
	new_pitch.emit(AudioManager.random.randf_range(pitch_min, pitch_max))
