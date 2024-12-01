class_name AnimationEventPlayer
extends AnimationPlayer

func emit_event_signal(event_signal : Signal):
	event_signal.emit()
