extends Resource
class_name DropData

@export var drops_scene : Dictionary = {}
@export var drop_items : Array[ChanceData]


func get_drop_items():
	return drop_items


func get_drops_scene():
	return drops_scene


func get_drop_scene(item):
	if get_drops_scene().has(item):
		return get_drops_scene()[item].instantiate()
	return null


func drop(drop_position:Vector3, receiver:Character) -> Array:
	var total_item_chance : float = 0
	var item_chances : Array = []
	for item in get_drop_items():
		var item_chance : Array = [item, total_item_chance]
		total_item_chance += get_item_chance(item, receiver)
		item_chance.append(total_item_chance)
		
		item_chances.append(item_chance)
	
	var random_chance : int = randi_range(1, total_item_chance)
	var choosen_item = null
	for item_chance in item_chances:
		if random_chance > item_chance[1] and random_chance <= item_chance[2]:
			choosen_item = item_chance[0]
	
	var choosen_item_object = null
	if choosen_item:
		choosen_item_object = choose_item(choosen_item, drop_position)
	
	return [choosen_item, choosen_item_object]


func choose_item(choosen_item, drop_position:Vector3) -> Node3D:
	var object = get_drop_scene(choosen_item.item)
	if object:
		Global.add_child(object)
		
		object.global_position = drop_position
	return object


func get_item_chance(item, receiver) -> float:
	return item.get_chance(receiver)
