class_name StateFloatParameter
extends StateValueParameter

@export var value := 0.0 :
	get: return value
	set(new_value) :
		comparison_value = new_value
		value = new_value

func _init() -> void:
	super._init()
	comparison_value = value
