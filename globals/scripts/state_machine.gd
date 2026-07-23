extends Node
class_name StateMachine


signal state_changed(old_state: StringName, new_state: StringName)

var current_state: StringName = &""

var _enter_callbacks: Dictionary = {} 
var _exit_callbacks: Dictionary = {}  

func register_state(state_name: StringName, on_enter: Callable = Callable(), on_exit: Callable = Callable()) -> void:
	_enter_callbacks[state_name] = on_enter
	_exit_callbacks[state_name] = on_exit

func change_states(new_state: StringName, args = null) -> void:
	if current_state != &"" and _exit_callbacks.has(current_state):
		var exit_cb: Callable = _exit_callbacks[current_state]
		if exit_cb.is_valid():
			exit_cb.call()

	var old_state := current_state
	current_state = new_state

	if _enter_callbacks.has(new_state):
		var enter_cb: Callable = _enter_callbacks[new_state]
		if enter_cb.is_valid():
			enter_cb.call(args)

	state_changed.emit(old_state, new_state)

func physics_process(_delta: float) -> void:
	pass
