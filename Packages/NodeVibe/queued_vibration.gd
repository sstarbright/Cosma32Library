class_name QueuedVibration
extends Reference

var controller = 0
var strength = 0.0
var time = 1.0

func process(delta):
	time -= delta
	return time <= 0.0
