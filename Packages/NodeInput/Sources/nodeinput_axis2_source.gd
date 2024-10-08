class_name InputAxis2
extends InputSource

var controller = 0
@export var x_axis := JOY_AXIS_LEFT_X
@export var y_axis := JOY_AXIS_LEFT_Y
@export var deadzone = 0.0 # (float, 0, 0.99, 0.01)
var deadzone_length_squared = 0.0
var deadzone_length = 0.0
var deadzone_ratio

var current_length = 0.0

func size():
	return InputValueSize.DOUBLE

func _ready():
	deadzone_length_squared = (deadzone * deadzone) + (deadzone * deadzone)
	deadzone_length = sqrt(deadzone_length_squared)
	deadzone_ratio = 1/(1-deadzone_length)

func raw():
	return Vector2(Input.get_joy_axis(controller, x_axis), Input.get_joy_axis(controller, y_axis))

func bool():
	previous = current
	current = raw().length_squared() >= deadzone_length_squared
	down = current && !previous
	up = !current && previous
	changed = down || up

func float():
	previous = current
	current_length = raw().length()
	current = min(max(abs(current_length)-deadzone_length, 0) * deadzone_ratio, 1.0) * sign(current_length)
	changed = !is_equal_approx(previous, current)

func vector():
	previous = current
	current = raw()
	current = Vector2(
		max(abs(current.x)-deadzone_length, 0) * sign(current.x) * deadzone_ratio,
		max(abs(current.y)-deadzone_length, 0) * sign(current.y) * deadzone_ratio
	)
	changed = !(previous.is_equal_approx(current))
