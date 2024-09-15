class_name InputButton
extends InputSource

enum InputButtonContribution {
	UP_OR_POSITIVE,
	DOWN_OR_NEGATIVE,
	LEFT,
	RIGHT
}

enum InputButtonID {
	FACE_UP = 3,
	FACE_DOWN = 0,
	FACE_LEFT = 2,
	FACE_RIGHT = 1,
	LEFT_SHOULDER = 4,
	RIGHT_SHOULDER = 5,
	LEFT_TRIGGER = 6,
	RIGHT_TRIGGER = 7,
	LEFT_STICK = 8,
	RIGHT_STICK = 9,
	SELECT = 10,
	START = 11,
	DPAD_UP = 12,
	DPAD_DOWN = 13,
	DPAD_LEFT = 14,
	DPAD_RIGHT = 15,
	VR_BOTTOM_BUTTON = 7,
	VR_TOP_BUTTON = 1,
}

export(InputButtonContribution) var contribution
var contribution_float = 1.0
var contribution_vector = Vector2.UP
var controller = 0
export(InputButtonID) var button = InputButtonID.FACE_UP

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
		InputButtonContribution.RIGHT:
			contribution_vector = Vector2.RIGHT
	
	#if OS.has_feature("web"):
		#match button:
			#InputButtonID.LEFT_STICK:
				#button = InputButtonID.SELECT
			#InputButtonID.RIGHT_STICK:
				#button = InputButtonID.START
			#InputButtonID.SELECT:
				#button = InputButtonID.LEFT_STICK
			#InputButtonID.START:
				#button = InputButtonID.RIGHT_STICK
			

func raw():
	return Input.is_joy_button_pressed(controller, button)

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
