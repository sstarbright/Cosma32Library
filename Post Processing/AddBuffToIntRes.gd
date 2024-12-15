class_name AddBuffToIntRes
extends BackBufferCopy

func _ready() -> void:
	PostProcessEngine.internal_resolution_changed.connect(Callable(self,"internal_resolution_changed"))
	position = PostProcessEngine.internal_resolution
	scale = Vector2(PostProcessEngine.internal_resolution)/100.0

func internal_resolution_changed(_old_resolution: Vector2i, new_resolution: Vector2i):
	position = new_resolution
	scale = Vector2(new_resolution)/100.0
