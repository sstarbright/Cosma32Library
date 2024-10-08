class_name InputKey
extends InputSource

enum InputKeyContribution {
	UP_OR_POSITIVE,
	DOWN_OR_NEGATIVE,
	LEFT,
	RIGHT
}

@export var key := KEY_A
@export var contribution: InputKeyContribution
var contribution_float = 1.0
var contribution_vector = Vector2.UP
var controller = 0

func size():
	return InputValueSize.HALF

func _ready():
	match contribution:
		InputKeyContribution.UP_OR_POSITIVE:
			contribution_float = 1.0
			contribution_vector = Vector2.UP
		InputKeyContribution.DOWN_OR_NEGATIVE:
			contribution_float = -1.0
			contribution_vector = Vector2.DOWN
		InputKeyContribution.LEFT:
			contribution_vector = Vector2.LEFT
		InputKeyContribution.RIGHT:
			contribution_vector = Vector2.RIGHT

func raw():
	return Input.is_physical_key_pressed(key)

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
