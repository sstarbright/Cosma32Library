class_name NodeInputRemapObject
extends RefCounted

var device_id
var input_id
var type
var bias
var sensitivity
var deadzone

func _init(dev_id, in_id, typ, bia = 1.0, sens = 0.5, deadz = 0.0):
	device_id = dev_id
	input_id = in_id
	type = typ
	bias = bia
	sensitivity = sens
	deadzone = deadz
