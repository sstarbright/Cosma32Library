class_name StateNode
extends NodeStates

var enabled := false
@export var dependency : StateParameter

signal state_entered
signal state_exited

func _ready() -> void:
	if dependency == null:
		dependency = StateParameter.new()

func enter_state(entered_on_start := false) -> bool:
	if !enabled || entered_on_start:
		state_entered.emit()
		enabled = true
		get_parent().current_state = self
		return false
	else:
		return true

func leave_state(_cancel_events := false) -> bool:
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

func is_active():
	return get_parent().current_state == self
