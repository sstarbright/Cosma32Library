class_name StateOrParameter
extends StateParameter

@export var parameters : Array[StateParameter]
var is_true := false

func parameter_true() -> bool:
	is_true = false
	for parameter in parameters:
		is_true = is_true || parameter.parameter_true()
	return is_true
