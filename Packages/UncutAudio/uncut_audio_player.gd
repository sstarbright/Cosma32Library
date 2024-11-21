class_name UncutAudioPlayer
extends AudioStreamPlayer


func _ready():
	var _finished = finished.connect(Callable(self, "queue_free"))

func audio_player_process(_delta):
	pass
