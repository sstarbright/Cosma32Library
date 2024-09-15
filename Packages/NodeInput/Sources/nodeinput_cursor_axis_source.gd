class_name InputCursorAxis
extends InputSource

enum InputAxisContribution {
	X_OR_UP,
	Y_OR_DOWN,
	LEFT,
	RIGHT
}

enum InputAxisID {
	X,
	Y
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
export var clamping = 1.0
var deadzone_ratio
var cursor_access
export var sensitivity = 0.5

var previousFloat = 0.0

func size():
	return InputValueSize.SINGLE

func _input(event):
	cursor_access.input(event)

func _ready():
	if axis == InputAxisID.X:
		cursor_access = InputCursorAxisX.new(sensitivity, clamping)
	else:
		cursor_access = InputCursorAxisY.new(sensitivity, clamping)
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
	return cursor_access.cursor_pos*direction

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
