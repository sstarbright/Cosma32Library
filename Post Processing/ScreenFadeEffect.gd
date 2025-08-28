class_name ScreenFadeEffect
extends AddColToIntRes

signal fading_completed

var current_tween : Tween

func _ready():
	super._ready()
	current_tween = get_tree().create_tween()
	current_tween.pause()

func fade_in(fade_time : float, blend_mode : CanvasItemMaterial.BlendMode, fade_color := Color.WHITE):
	show()
	material.blend_mode = blend_mode
	color = fade_color
	if current_tween.is_valid():
		current_tween.kill()
	current_tween = get_tree().create_tween()
	current_tween.tween_property(self, "color:a", 0.0, fade_time).set_trans(Tween.TRANS_CUBIC)
	current_tween.tween_callback(Callable(self, "emit_signal").bind("fading_completed"))
	current_tween.tween_callback(Callable(self, "hide"))

func fade_out(fade_time : float, blend_mode : CanvasItemMaterial.BlendMode, fade_color := Color.WHITE):
	show()
	material.blend_mode = blend_mode
	color = fade_color
	color.a = 0.0
	if current_tween.is_valid():
		current_tween.kill()
	current_tween = get_tree().create_tween()
	current_tween.tween_property(self, "color:a", 1.0, fade_time).set_trans(Tween.TRANS_CUBIC)
	current_tween.tween_callback(Callable(self, "emit_signal").bind("fading_completed"))
