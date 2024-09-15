class_name UncutAudioPlayer3D
extends AudioStreamPlayer3D

const mute_db = 0.00001

var target
var fade_out = false
var fade_speed = 1.0
var fade_pos = 0.0
var start_db
var looping = false

func _ready():
	var _finished = connect("finished", self, "queue_free")

func audio_player_process(delta):
	if !fade_out:
		if is_instance_valid(target):
			global_translation = target.global_translation
		elif looping:
			start_db = unit_db
			fade_out = true
	else:
		fade_pos += delta
		if fade_pos >= fade_speed:
			queue_free()
		unit_db = linear2db(lerp(start_db, mute_db, fade_pos/fade_speed))

func set_target(node):
	if is_instance_valid(node):
		translation = node.global_translation
		target = node
	else:
		queue_free()

func set_stream(new_stream):
	if new_stream is AudioStreamSample && new_stream.loop_mode != AudioStreamSample.LOOP_DISABLED:
		looping = true
	.set_stream(new_stream)
