extends Node

const consume_time = 0.1

var existing_streams = Dictionary()
var audio_space_2d
var audio_space_3d
onready var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	audio_space_2d = Node2D.new()
	audio_space_2d.name = "AudioSpace2D"
	get_node("/root").call_deferred("add_child", audio_space_2d)
	audio_space_3d = Spatial.new()
	audio_space_3d.name = "AudioSpace3D"
	get_node("/root").call_deferred("add_child", audio_space_3d)

func _process(delta):
	for existing_stream_name in existing_streams.keys():
		existing_streams[existing_stream_name] -= delta
		if existing_streams[existing_stream_name] <= 0.0:
			existing_streams.erase(existing_stream_name)
	
	for child in get_children():
		child.audio_player_process(delta)
	for child in audio_space_2d.get_children():
		child.audio_player_process(delta)
	for child in audio_space_3d.get_children():
		child.audio_player_process(delta)

func clear():
	for child in get_children():
		child.queue_free()
	for child in audio_space_2d.get_children():
		child.queue_free()
	for child in audio_space_3d.get_children():
		child.queue_free()

func add_2d_listener(node):
	var new_listener = UncutAudioListener2D.new()
	new_listener.target = node
	audio_space_2d.add_child(new_listener)

func add_3d_listener(node):
	var new_listener = UncutAudioListener3D.new()
	new_listener.target = node
	audio_space_3d.add_child(new_listener)

func play(stream, bus, low_pitch = 1.0, high_pitch = 1.0, volume = 0.0):
	if !existing_streams.has(stream.resource_path):
		existing_streams[stream.resource_path] = consume_time
		play_immediate(stream, bus, low_pitch, high_pitch, volume)

func play_immediate(stream, bus, low_pitch = 1.0, high_pitch = 1.0, volume = 0.0):
	var new_player = UncutAudioPlayer.new()
	new_player.pause_mode = PAUSE_MODE_PROCESS
	new_player.set_volume_db(volume)
	new_player.bus = bus
	new_player.autoplay = true
	new_player.set_stream(stream)
	new_player.pitch_scale = rand_range(low_pitch, high_pitch)
	new_player.mix_target = AudioStreamPlayer.MIX_TARGET_STEREO
	add_child(new_player)

func play2d(stream, bus, target, low_pitch = 1.0, high_pitch = 1.0, volume = 0.0, fade_speed = 1.0):
	var new_player = UncutAudioPlayer2D.new()
	new_player.pause_mode = PAUSE_MODE_PROCESS
	new_player.set_volume_db(volume)
	new_player.bus = bus
	new_player.autoplay = true
	new_player.set_stream(stream)
	new_player.set_target(target)
	new_player.fade_speed = fade_speed
	new_player.pitch_scale = rand_range(low_pitch, high_pitch)
	new_player.panning_strength = 0.0
	audio_space_2d.add_child(new_player)

func play3d(stream, bus, target, low_pitch = 1.0, high_pitch = 1.0, distance = 50.0, volume = 0.0, fade_speed = 1.0):
	var new_player = UncutAudioPlayer3D.new()
	new_player.pause_mode = PAUSE_MODE_PROCESS 
	new_player.set_attenuation_filter_cutoff_hz(20500.0)
	new_player.set_unit_size(distance)
	new_player.set_unit_db(volume)
	new_player.set_out_of_range_mode(AudioStreamPlayer3D.OUT_OF_RANGE_PAUSE)
	new_player.bus = bus
	new_player.autoplay = true
	new_player.set_stream(stream)
	new_player.set_target(target)
	new_player.fade_speed = fade_speed
	new_player.pitch_scale = rand_range(low_pitch, high_pitch)
	new_player.panning_strength = 0.0
	audio_space_3d.add_child(new_player)
