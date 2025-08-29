extends Control

@export var noise : FastNoiseLite

func _process(_delta: float) -> void:
	noise.seed = randi()
