class_name AudioStreamSine
extends AudioStreamPlayer

@export var vol_speed = 1.0
@export var pitch_speed = 1.0
@export var vol_size = Vector2(0.0, 1.0)
@export var pitch_size = Vector2(1.0, 1.0)
var time = 0.0

func _process(delta: float) -> void:
	time += delta
	volume_db = linear_to_db(lerp(vol_size.x, vol_size.y, (sin(time*vol_speed)+1.0)/2.0))
	pitch_scale = lerp(pitch_size.x, pitch_size.y, (sin(time*pitch_speed)+1.0)/2.0)
