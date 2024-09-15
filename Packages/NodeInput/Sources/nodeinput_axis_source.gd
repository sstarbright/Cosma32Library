class_name InputAxis
extends InputSource

enum InputAxisContribution {
	X_OR_UP,
	Y_OR_DOWN,
	LEFT,
	RIGHT
}

enum InputAxisID {
	LEFT_STICK_X,
	LEFT_STICK_Y,
	RIGHT_STICK_X,
	RIGHT_STICK_Y,
	AXIS_4,
	AXIS_5,
	LEFT_TRIGGER,
	RIGHT_TRIGGER,
	AXIS_8,
	AXIS_9,
	AXIS_10,
	VR_TRIGGER = 2,
	VR_GRIP = 4
}

export(InputAxisContribution) var contribution
var contribution_max = 1.0
var contribution_min = 0.0
var contribution_vector = Vector2.UP
var direction = 1.0
var controller = 0
export(InputAxisID) var axis
export(float, 0, 0.99, 0.01) var deadzone = 0.0
export(float, -1, 1, 2) var bias = 1.0
var deadzone_ratio

var previousFloat = 0.0

func size():
	return InputValueSize.SINGLE

func _ready():
	deadzone_ratio = 1/(1-deadzone)
	if bias > 0:
		contribution_max = 1.0
		contribution_min = 0.0
	else:
		contribution_max = 0.0
		contribution_min = -1.0
		
	match contribution:
		InputAxisContribution.X_OR_UP:
			contribution_vector = Vector2.DOWN
		InputAxisContribution.Y_OR_DOWN:
			contribution_vector = Vector2.RIGHT

func raw():
	return Input.get_joy_axis(controller, axis)*direction

func bool():
	previous = current
	current = abs(clamp(raw(), contribution_min, contribution_max)) >= deadzone
	down = current && !previous
	up = !current && previous
	changed = down || up

func float():
	previous = current
	current = raw()
	current = max(abs(current)-deadzone, 0) * sign(current) * deadzone_ratio
	changed = !is_equal_approx(previous, current)

func vector():
	previous = current
	current = raw()
	current = max(abs(current)-deadzone, 0) * sign(current) * deadzone_ratio
	changed = !is_equal_approx(previousFloat, current)
	previousFloat = current
	current *= contribution_vector
