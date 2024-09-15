class_name InputRemapBool
extends InputRemapValue

signal on_down()
signal on_up()

var down = false
var up = false

func _ready():
	var children = get_children()
	for child in children:
		if child is InputSource:
			sources.append(child)
			child.start(self)
	current = false

func _physics_process(delta):
	._physics_process(delta)
	down = false
	up = false
	for source in sources:
		source.bool()
		if (source.changed):
			current = source.current
			changed = true
			down = source.down
			up = source.up
			
			if down:
				do_down()
			elif up:
				do_up()
			break

func do_down():
	emit_signal("on_down")

func do_up():
	emit_signal("on_up")
