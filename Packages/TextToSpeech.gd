extends Node

var voices : PackedStringArray
var tts_occupied := false

func _ready():
	pass
	#voices = DisplayServer.tts_get_voices_for_language("en")
	#DisplayServer.tts_set_utterance_callback(DisplayServer.TTS_UTTERANCE_ENDED, Callable(self, "speaking_finished"))

func talk(voice: int, text := "THIS LINE IS EMPTY", pitch := 1.0, speed := 1.0, volume := 50, interrupt := false):
	var should_speak := interrupt || !tts_occupied
	if interrupt && tts_occupied:
		DisplayServer.tts_stop()
	if should_speak:
		DisplayServer.tts_speak(text, voices[min(voice, voices.size()-1)], clampi(volume, 0, 100), clampf(pitch, 0.0, 2.0), clampf(speed, 0.1, 10.0))
		tts_occupied = true

func speaking_finished(_id : int):
	tts_occupied = false
