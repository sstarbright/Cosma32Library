class_name InputCursorAxisY

var cursor_pos = 0.0
var sensitivity
var clamping

func _init(sens, clmp = 1.0):
	sensitivity = sens
	clamping = clmp

func input(event):
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative*sensitivity
		cursor_pos += mouse_delta.y
		cursor_pos = clamp(cursor_pos, -clamping, clamping)
