class_name AddTexToExtRes
extends TextureRect

func _ready() -> void:
	PostProcessEngine.external_resolution_changed.connect(Callable(self,"external_resolution_changed"))
	size = PostProcessEngine.external_resolution

func external_resolution_changed(_old_resolution: Vector2i, new_resolution: Vector2i):
	size = new_resolution
