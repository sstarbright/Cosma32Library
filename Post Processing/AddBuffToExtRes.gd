class_name AddBuffToExtRes
extends BackBufferCopy

func _ready() -> void:
	PostProcessEngine.external_resolution_changed.connect(Callable(self,"external_resolution_changed"))
	position = PostProcessEngine.external_resolution
	scale = Vector2(PostProcessEngine.external_resolution)/100.0

func external_resolution_changed(_old_resolution: Vector2i, new_resolution: Vector2i):
	position = new_resolution
	scale = Vector2(new_resolution)/100.0
