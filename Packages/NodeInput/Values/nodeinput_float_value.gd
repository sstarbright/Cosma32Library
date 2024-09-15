class_name InputFloat
extends InputValue

var collecting_half = false
var collecting_half_index = 0
var num_halfs = 0

func _ready():
	var children = get_children()
	for child in children:
		if child is InputSource:
			child.current = 0.0
			if child.size() < InputSource.InputValueSize.SINGLE:
				child.current = 0.0
				if collecting_half:
					collecting_half = false
					if child.contribution < 1:
						sources[collecting_half_index].pos = child
					else:
						sources[collecting_half_index].neg = child
				else:
					collecting_half = true
					collecting_half_index = sources.size()
					sources.append(InputHalfToSingle.new())
					num_halfs += 1
					
					if child.contribution < 1:
						sources[collecting_half_index].pos = child
						sources[collecting_half_index].neg = InputSource.new()
					else:
						sources[collecting_half_index].pos = InputSource.new()
						sources[collecting_half_index].neg = child
					
			else:
				sources.append(child)
				child.start(self)
	current = 0.0

func _physics_process(_delta):
	for source in sources:
		source.float()
		if (source.changed):
			current = source.current
			changed = true
			break
