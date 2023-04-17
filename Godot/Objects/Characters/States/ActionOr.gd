class_name ActionOr
extends ActionData

@export_enum("First", "Second") var choose_child_number : int

var possible_actions : Array[ActionData] = []


func _ready():
	for child in get_children():
		if child is ActionData:
			possible_actions.append(child)


func get_action_data(body) -> ActionData:
	if get_chosen(body):
		return possible_actions[choose_child_number]
	return possible_actions[1] if choose_child_number == 0 else possible_actions[0]


func get_chosen(body) -> bool:
	return true
