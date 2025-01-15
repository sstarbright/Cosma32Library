class_name StateAndParameter
extends StateParameter

@export var parameters : Array[StateParameter]
var is_true := true

func parameter_true() -> bool:
	is_true = parameters.size() > 0
	for parameter in parameters:
		is_true = is_true && parameter.parameter_true()
	return is_true
