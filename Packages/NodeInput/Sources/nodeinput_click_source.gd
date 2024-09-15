class_name InputClick
extends InputSource

enum InputButtonContribution {
	UP_OR_POSITIVE,
	DOWN_OR_NEGATIVE,
	LEFT,
	RIGHT
}

enum InputButtonID {
	LEFT = 1,
	RIGHT = 2,
	MIDDLE = 3,
	EXTRA_1 = 8,
	EXTRA_2 = 9,
	WHEEL_UP = 4,
	WHEEL_DOWN = 5,
	WHEEL_LEFT = 6,
	WHEEL_RIGHT = 7
}

export(InputButtonContribution) var contribution
var contribution_float = 1.0
var contribution_vector = Vector2.UP
var controller = 0
export(InputButtonID) var button = InputButtonID.LEFT

func size():
	return InputValueSize.HALF

func _ready():
	match contribution:
		InputButtonContribution.UP_OR_POSITIVE:
			contribution_float = 1.0
			contribution_vector = Vector2.UP
		InputButtonContribution.DOWN_OR_NEGATIVE:
			contribution_float = -1.0
			contribution_vector = Vector2.DOWN
		InputButtonContribution.LEFT:
			contribution_vector = Vector2.LEFT
		InputButtonContribution.Right:
			contribution_vector = Vector2.RIGHT

func raw():
	return Input.is_mouse_button_pressed(int(button))

func bool():
	previous = current
	current = raw()
	down = current && !previous
	up = !current && previous
	changed = down || up

func float():
	previous = current
	current = contribution_float * float(raw())
	changed = current != previous

func vector():
	previous = current
	current = contribution_vector * float(raw())
	changed = current != previous
