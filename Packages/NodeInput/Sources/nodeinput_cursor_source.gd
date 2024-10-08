class_name InputCursor
extends InputSource

const SCREEN_CENTER = Vector2(0.5, 0.5)

@export var deadzone: float = 0.0
var deadzone_length_squared = 0.0
var deadzone_length = 0.0
var deadzone_ratio
@export var sensitivity = 0.5
@export var is_relative = false
var delta
var cursor_pos = Vector2.ZERO

var current_length = 0.0

@export var length_limit = 1.0

func size():
	return InputValueSize.DOUBLE

func _ready():
	deadzone_length_squared = (deadzone * deadzone) + (deadzone * deadzone)
	deadzone_length = sqrt(deadzone_length_squared)
	deadzone_ratio = 1/(1-deadzone_length)
	
func start(parent_node):
	super.start(parent_node)
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		parent_node.disable_source(name)
	
func _input(event):
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative*sensitivity
		if is_relative:
			cursor_pos = Vector2(
				max(abs(mouse_delta.x)-deadzone_length, 0) * sign(mouse_delta.x) * deadzone_ratio,
				max(abs(mouse_delta.y)-deadzone_length, 0) * sign(mouse_delta.y) * deadzone_ratio
			)
		else:
			cursor_pos += Vector2(
				max(abs(mouse_delta.x)-deadzone_length, 0) * sign(mouse_delta.x) * deadzone_ratio,
				max(abs(mouse_delta.y)-deadzone_length, 0) * sign(mouse_delta.y) * deadzone_ratio
			)
		cursor_pos = cursor_pos.limit_length(length_limit)

func _physics_process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		parent.enable_source(name)
		cursor_pos = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_ESCAPE) && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		parent.disable_source(name)

func bool():
	previous = current
	current = cursor_pos.length_squared() >= deadzone_length_squared
	down = current && !previous
	up = !current && previous
	changed = down || up

func float():
	previous = current
	current_length = cursor_pos.length()
	current = min(max(abs(current_length)-deadzone_length, 0) * deadzone_ratio, 1.0) * sign(current_length)
	changed = !is_equal_approx(previous, current)

func vector():
	previous = current
	current = cursor_pos
	changed = !(previous.is_equal_approx(current))
