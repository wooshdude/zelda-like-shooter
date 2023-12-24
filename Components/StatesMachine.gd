extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready():
	for state in get_children():
		if state is State:
			states[state.name.to_lower()] = state
			state.transition.connect(on_child_transitioned)
	
	current_state = initial_state
	
	if current_state:
		current_state.enter()
		current_state.enter_children()


func _process(delta):
	if current_state:
		current_state.update(delta)
		current_state.update_children(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
		current_state.physics_update_children(delta)


func on_child_transitioned(state: State, new_state_name: String):
	if not state == current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	print(new_state.name + " entered")
	new_state.enter()
	new_state.enter_children()
	current_state = new_state
