class_name InputValue
extends NodeInput

var sources = []
var disabled_sources = []
var current
var previous
var changed
@export var base_process_mode := ProcessMode.PROCESS_MODE_INHERIT

func _physics_process(_delta):
	previous = current
	changed = false

func disable_source(source_name):
	var disable_index = 0
	for source in sources:
		if source.name == source_name:
			disabled_sources.append(source)
			sources.remove(disable_index)
			break
		disable_index += 1

func enable_source(source_name):
	var enable_index = 0
	for source in disabled_sources:
		if source.name == source_name:
			sources.append(source)
			disabled_sources.remove(enable_index)
			break
		enable_index += 1

func disable():
	process_mode = Node.PROCESS_MODE_DISABLED

func enable():
	process_mode = base_process_mode
