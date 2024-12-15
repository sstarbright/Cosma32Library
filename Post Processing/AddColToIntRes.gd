class_name AddColToIntRes
extends ColorRect

func _ready() -> void:
	PostProcessEngine.internal_resolution_changed.connect(Callable(self,"internal_resolution_changed"))
	size = PostProcessEngine.internal_resolution

func internal_resolution_changed(_old_resolution: Vector2i, new_resolution: Vector2i):
	size = new_resolution
