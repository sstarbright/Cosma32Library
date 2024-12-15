class_name AddSubToExtRes
extends SubViewport

func _ready() -> void:
	PostProcessEngine.external_resolution_changed.connect(Callable(self,"external_resolution_changed"))
	size = PostProcessEngine.external_resolution

func external_resolution_changed(old_resolution: Vector2i, new_resolution: Vector2i):
	size = new_resolution
