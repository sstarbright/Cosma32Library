extends Node

enum MapType {
	MAP_FIRE_CONFIRM,
	MAP_MISSILE_CANCEL,
	MAP_START_PAUSE,
	MAP_BOOST,
	MAP_MOVE
}

enum InputType {
	BUTTON_FROM_NONE,
	BUTTON_FROM_JOYPAD,
	BUTTON_FROM_MOUSE,
	BUTTON_FROM_KEYBOARD,
	AXIS_FROM_JOYPAD,
	AXIS_FROM_MOUSE,
}

const controls_config_path = "user://controls.cfg"

var maps = Dictionary()

func add_single_map(controls_config, map_key, map, extra_key = ""):
	var full_key = str(map_key)+extra_key
	controls_config.set_value(full_key, "name", str(MapType.keys()[map_key])+extra_key)
	if map:
		controls_config.set_value(full_key, "device_id", map.device_id)
		controls_config.set_value(full_key, "input_id", map.input_id)
		controls_config.set_value(full_key, "type", map.type)
		controls_config.set_value(full_key, "bias", map.bias)
		controls_config.set_value(full_key, "sensitivity", 0.003)
		controls_config.set_value(full_key, "deadzone", 0.01 if map.type == InputType.AXIS_FROM_MOUSE else 0.25)
		controls_config.set_value(full_key, "count", 1)
	else:
		controls_config.set_value(full_key, "count", 0)

func load_controls():
	var controls_config = ConfigFile.new()
	controls_config.load(controls_config_path)
	var section_count = 0
	var new_map
	
	for section in controls_config.get_sections():
		if section.length() < 2:
			section_count = controls_config.get_value(section, "count")
			if section_count < 1:
				new_map = null
			elif section_count < 4:
				new_map = NodeInputRemapObject.new(\
				controls_config.get_value(section, "device_id"),\
				controls_config.get_value(section, "input_id"),\
				controls_config.get_value(section, "type"),\
				controls_config.get_value(section, "bias")\
				)
			else:
				new_map = NodeInput4RemapObject.new(\
				NodeInputRemapObject.new(\
				controls_config.get_value(section+"UP", "device_id"),\
				controls_config.get_value(section+"UP", "input_id"),\
				controls_config.get_value(section+"UP", "type"),\
				controls_config.get_value(section+"UP", "bias"),\
				controls_config.get_value(section+"UP", "sensitivity"),\
				controls_config.get_value(section+"UP", "deadzone")\
				) if controls_config.get_value(section+"UP", "count") > 0 else null,\
				NodeInputRemapObject.new(\
				controls_config.get_value(section+"DOWN", "device_id"),\
				controls_config.get_value(section+"DOWN", "input_id"),\
				controls_config.get_value(section+"DOWN", "type"),\
				controls_config.get_value(section+"DOWN", "bias"),\
				controls_config.get_value(section+"UP", "sensitivity"),\
				controls_config.get_value(section+"UP", "deadzone")\
				) if controls_config.get_value(section+"DOWN", "count") > 0 else null,\
				NodeInputRemapObject.new(\
				controls_config.get_value(section+"LEFT", "device_id"),\
				controls_config.get_value(section+"LEFT", "input_id"),\
				controls_config.get_value(section+"LEFT", "type"),\
				controls_config.get_value(section+"LEFT", "bias"),\
				controls_config.get_value(section+"UP", "sensitivity"),\
				controls_config.get_value(section+"UP", "deadzone")\
				) if controls_config.get_value(section+"LEFT", "count") > 0 else null,\
				NodeInputRemapObject.new(\
				controls_config.get_value(section+"RIGHT", "device_id"),\
				controls_config.get_value(section+"RIGHT", "input_id"),\
				controls_config.get_value(section+"RIGHT", "type"),\
				controls_config.get_value(section+"RIGHT", "bias"),\
				controls_config.get_value(section+"UP", "sensitivity"),\
				controls_config.get_value(section+"UP", "deadzone")\
				) if controls_config.get_value(section+"RIGHT", "count") > 0 else null\
				)
			maps[int(section)] = new_map

func save_controls():
	var controls_config = ConfigFile.new()
	var map
	
	for map_key in maps.keys():
		map = maps[map_key]
		if map is NodeInputRemapObject:
			add_single_map(controls_config, map_key, map)
		elif map is NodeInput4RemapObject:
			controls_config.set_value(str(map_key), "name", str(MapType.keys()[map_key]))
			controls_config.set_value(str(map_key), "count", 4)
			add_single_map(controls_config, map_key, map.up_map, "UP")
			add_single_map(controls_config, map_key, map.down_map, "DOWN")
			add_single_map(controls_config, map_key, map.left_map, "LEFT")
			add_single_map(controls_config, map_key, map.right_map, "RIGHT")
	
	controls_config.save(controls_config_path)

func add_source_from_map(parent_value, map, contribution):
	if !map:
		return false
	var new_source
	match map.type:
		InputType.BUTTON_FROM_JOYPAD:
			new_source = InputButton.new()
			new_source.controller = map.device_id
			new_source.button = map.input_id
			new_source.contribution = contribution
		InputType.BUTTON_FROM_MOUSE:
			new_source = InputClick.new()
			new_source.button = map.input_id
			new_source.contribution = contribution
		InputType.BUTTON_FROM_KEYBOARD:
			new_source = InputKey.new()
			new_source.key = map.input_id
			new_source.contribution = contribution
		InputType.AXIS_FROM_JOYPAD:
			new_source = InputAxis.new()
			new_source.controller = map.device_id
			new_source.axis = map.input_id
			new_source.direction = map.bias
			new_source.contribution = contribution
			new_source.deadzone = map.deadzone
		InputType.AXIS_FROM_MOUSE:
			new_source = InputCursorAxis.new()
			new_source.axis = map.input_id
			new_source.direction = map.bias
			new_source.contribution = contribution
			new_source.deadzone = map.deadzone
			new_source.sensitivity = map.sensitivity
	parent_value.add_child(new_source)
	return true

func load_map_as_sources(parent_value, map_type):
	if !maps.has(map_type):
		return
	var map = maps[map_type]
	if map is NodeInputRemapObject:
		add_source_from_map(parent_value, map, 0)
	elif map is NodeInput4RemapObject:
		add_source_from_map(parent_value, map.up_map, 0)
		if !add_source_from_map(parent_value, map.down_map, 1):
			add_source_from_map(parent_value, map.left_map, 1)
		else:
			add_source_from_map(parent_value, map.left_map, 2)
		add_source_from_map(parent_value, map.right_map, 3)
