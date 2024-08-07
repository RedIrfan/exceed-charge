extends Node
class_name StateMachine


@export var body : Node
@export var starting_state : State

var states : Dictionary = {}

var previous_state
var current_state
var next_state


func _ready():
	await Signal(body, 'ready')
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
	
	restart()


func restart():
	enter_state(starting_state.name)


func enter_state(state_name:String, msg=[]) -> bool:
	state_name = state_name.to_lower()
	if states.has(state_name):
		next_state = states[state_name]
		var next_state_condition = next_state.enter_condition(body, self, msg)
		
		if next_state_condition:
			if current_state:
				await current_state.exit()
				previous_state = current_state
		
			current_state = next_state
			current_state.body = body
			current_state.fsm = self
			current_state.enter(msg)
		return next_state_condition
	return false


func _physics_process(delta):
	if current_state:
		current_state.physics_process(delta)


func _process(delta):
	if current_state:
		current_state.process(delta)
