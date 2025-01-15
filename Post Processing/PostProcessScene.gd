class_name PostProcessScene
extends Node2D

@export var world_motion_blur : AccMotionBlurEffect
@export var ui_motion_blur : AccMotionBlurEffect
@export var game_fade_filter : ScreenFadeEffect
@export var screen_fade_filter : ScreenFadeEffect
@export var dither_filter : BackBufferCopy
@export var color_bleed_filter : BackBufferCopy
@export var sharpen_filter : BackBufferCopy
@export var game_layer : GameLayer
@export var ui_layer : UILayer
@export var audio_noise : AudioStreamPlayer

func _ready():
	PostProcessEngine.post_process_scene = self
