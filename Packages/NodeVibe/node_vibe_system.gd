extends Node

var vibrations = []
var total_vibrations = []
const weak_to_strong_ratio = 0.02

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	for _controller in range(4):
		total_vibrations.append(0.0)

func add_vibration(controller, strength, time):
	var new_vibration = QueuedVibration.new()
	new_vibration.controller = controller
	new_vibration.strength = strength
	new_vibration.time = time
	vibrations.append(new_vibration)

func _process(delta):
	var vibe_index = 0
	for vibe in vibrations:
		if vibe.process(delta):
			vibrations.remove(vibe_index)
			vibe_index -= 1
		else:
			total_vibrations[vibe.controller] = total_vibrations[vibe.controller]+vibe.strength
		vibe_index += 1
	for controller in range(4):
		Input.start_joy_vibration(controller, min(total_vibrations[controller], 1.0), min(total_vibrations[controller]*weak_to_strong_ratio, 1.0), delta)
		total_vibrations[controller] = 0.0
