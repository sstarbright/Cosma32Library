class_name UncutAudioPlayer2D
extends AudioStreamPlayer2D

const mute_db = 0.00001

var target
var fade_out = false
var fade_speed = 1.0
var fade_pos = 0.0
var start_db

func _ready():
	var _finished = connect("finished", self, "queue_free")

func audio_player_process(delta):
	if !fade_out:
		if is_instance_valid(target):
			global_position = target.global_position
		else:
			start_db = volume_db
			fade_out = true
	else:
		fade_pos += delta
		if fade_pos >= fade_speed:
			queue_free()
		volume_db = linear2db(lerp(start_db, mute_db, fade_pos/fade_speed))

func set_target(node):
	if is_instance_valid(node):
		position = node.global_position
		target = node
	else:
		queue_free()
