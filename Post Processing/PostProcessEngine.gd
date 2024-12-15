extends Node

signal internal_resolution_changed(old_resolution: Vector2i, new_resolution: Vector2i)
signal external_resolution_changed(old_resolution: Vector2i, new_resolution: Vector2i)

var post_process_scene : PostProcessScene
var internal_resolution := Vector2i(480, 360)
var external_resolution := Vector2i(1440, 1080)

func set_internal_resolution(new_resolution: Vector2i):
	internal_resolution_changed.emit(internal_resolution, new_resolution)
	internal_resolution = new_resolution

func set_external_resolution(new_resolution: Vector2i):
	external_resolution_changed.emit(external_resolution, new_resolution)
	external_resolution = new_resolution
