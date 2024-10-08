class_name UncutAudioPlayer
extends AudioStreamPlayer


func _ready():
	var _finished = connect("finished", Callable(self, "queue_free"))

func audio_player_process(_delta):
	pass
