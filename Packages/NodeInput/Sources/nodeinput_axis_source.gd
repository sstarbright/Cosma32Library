class_name InputAxis
extends InputSource

enum InputAxisContribution {
	X_OR_UP,
	Y_OR_DOWN,
	LEFT,
	RIGHT
}

@export var contribution: InputAxisContribution
var contribution_max = 1.0
var contribution_min = 0.0
var contribution_vector = Vector2.UP
var direction = 1.0
var controller = 0
@export var axis:= JOY_AXIS_LEFT_X
@export var deadzone = 0.0 # (float, 0, 0.99, 0.01)
@export var bias = 1.0 # (float, -1, 1, 2)
var deadzone_ratio

var previousFloat = 0.0

func size():
	return InputValueSize.SINGLE

func _ready():
	deadzone_ratio = 1/(1-deadzone)
	if bias > 0:
		contribution_max = 1.0
		contribution_min = 0.0
		direction = 1.0
	else:
		contribution_max = 0.0
		contribution_min = -1.0
		direction = -1.0
		
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
