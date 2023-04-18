class_name ActionOr
extends ActionData

@export var default_child_number : int = 1

var possible_actions : Array[ActionData] = []


func _ready():
	for child in get_children():
		if child is ActionData:
			possible_actions.append(child)


func get_action_data(body) -> ActionData:
	var chosen = get_chosen(body)
	if chosen != null:
		return chosen
	return possible_actions[default_child_number - 1]


func get_chosen(body) -> ActionData:
	return null
