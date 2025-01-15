class_name StateVec3Parameter
extends StateValueParameter

@export var value := Vector3.ZERO :
	get: return value
	set(new_value) :
		comparison_value = new_value
		value = new_value

func _init() -> void:
	super._init()
	comparison_value = value
