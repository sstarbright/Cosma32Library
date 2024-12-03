class_name AnimationEventPlayer
extends AnimationPlayer

func emit_event_signal(event_signal : Signal, enabled := true):
	if enabled:
		event_signal.emit()
		print("Event - " + event_signal.get_object().name)