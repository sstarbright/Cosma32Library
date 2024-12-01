class_name StateNode
extends NodeStates

@export var enabled := false

signal state_entered
signal state_exited

func _ready() -> void:
	if enabled:
		enter_state(true)

func enter_state(entered_on_ready := false) -> bool:
	if !enabled || entered_on_ready:
		state_entered.emit()
		enabled = true
		return false
	else:
		return true

func leave_state() -> bool:
	if enabled:
		state_exited.emit()
		enabled = false
		return true
	else:
		return false

func process_state(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if enabled:
		process_state(delta)
