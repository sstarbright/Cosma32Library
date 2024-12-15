class_name AccMotionBlurEffect
extends TextureRect

@export var viewport_texture : ViewportTexture
@export var blur_viewport_texture : ViewportTexture
@export var enabled = true
@export var strength_curve : Curve
@export_range(0.0, 0.97) var strength : float :
	set(value):
		set_blur_strength(value)
@export_range(0.0, 1.0) var delay := 0.0
var elapsed_time := 0.0

func _ready():
	await RenderingServer.frame_post_draw
	texture = ImageTexture.create_from_image(viewport_texture.get_image())
	PostProcessEngine.internal_resolution_changed.connect(Callable(self,"internal_resolution_changed"))
	size = PostProcessEngine.internal_resolution

func _process(delta):
	if enabled:
		elapsed_time += delta
		if elapsed_time >= delay:
			elapsed_time = 0.0
			await RenderingServer.frame_post_draw
			texture.update(blur_viewport_texture.get_image())
	else:
		elapsed_time = 0.0

func set_blur_strength(new_strength: float):
	modulate.a = strength_curve.sample(new_strength)

func internal_resolution_changed(_old_resolution: Vector2i, new_resolution: Vector2i):
	size = new_resolution
