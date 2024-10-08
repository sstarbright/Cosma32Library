class_name InputVector
extends InputValue

@export var length_limit = 1.0

var collecting_half = false
var collecting_half_index = 0
var collecting_half_count = 0
var num_halfs = 0

var collecting_single = false
var collecting_single_index = 0
var num_singles = 0

func _ready():
	var children = get_children()
	for child in children:
		if child is InputSource:
			child.current = Vector2.ZERO
			match child.size():
				InputSource.InputValueSize.HALF:
					if collecting_half:
						match child.contribution:
							0:
								sources[collecting_half_index].y_neg = child
							1:
								sources[collecting_half_index].y_pos = child
							2:
								sources[collecting_half_index].x_neg = child
							_:
								sources[collecting_half_index].x_pos = child
						collecting_half_count += 1
						if collecting_half_count >= 3:
							collecting_half = false
					else:
						collecting_half = true
						collecting_half_index = sources.size()
						collecting_half_count = 0
						sources.append(InputHalfToDouble.new())
						num_halfs += 1
						sources[collecting_half_index].name = "HalfToDouble" + str(num_halfs)
						match child.contribution:
							0:
								sources[collecting_half_index].y_neg = child
								sources[collecting_half_index].y_pos = InputSource.new()
								sources[collecting_half_index].x_neg = InputSource.new()
								sources[collecting_half_index].x_pos = InputSource.new()
							1:
								sources[collecting_half_index].y_pos = child
								sources[collecting_half_index].y_neg = InputSource.new()
								sources[collecting_half_index].x_neg = InputSource.new()
								sources[collecting_half_index].x_pos = InputSource.new()
							2:
								sources[collecting_half_index].x_neg = child
								sources[collecting_half_index].y_pos = InputSource.new()
								sources[collecting_half_index].y_neg = InputSource.new()
								sources[collecting_half_index].x_pos = InputSource.new()
							_:
								sources[collecting_half_index].x_pos = child
								sources[collecting_half_index].y_pos = InputSource.new()
								sources[collecting_half_index].y_neg = InputSource.new()
								sources[collecting_half_index].x_neg = InputSource.new()
				InputSource.InputValueSize.SINGLE:
					if collecting_single:
						collecting_single = false
						if child.contribution < 1:
							sources[collecting_single_index].x = child
						else:
							sources[collecting_single_index].y = child
					else:
						collecting_single = true
						collecting_single_index = sources.size()
						sources.append(InputSingleToDouble.new())
						num_singles += 1
						sources[collecting_single_index].name = "SingleToDouble" + str(num_singles)
						if child.contribution < 1:
							sources[collecting_single_index].x = child
							sources[collecting_single_index].y = InputSource.new()
						else:
							sources[collecting_single_index].x = InputSource.new()
							sources[collecting_single_index].y = child
				_:
					sources.append(child)
					child.start(self)
	current = Vector2.ZERO

func _physics_process(_delta):
	for source in sources:
		source.vector()
		if (source.changed):
			current = source.current.limit_length(length_limit)
			changed = true
			break
