class_name InputRemapValue
extends InputValue

enum MapType {
	MAP_FIRE_CONFIRM,
	MAP_MISSILE_CANCEL,
	MAP_START_PAUSE,
	MAP_BOOST,
	MAP_MOVE
}

@export var map_type: MapType

func _ready():
	NodeInputRemap.load_map_as_sources(self, map_type)
