extends Resource
class_name DropData

const CARD_PICKUPABLE = preload("res://Objects/Pickupable/CardPickupable/CardPickupable.tscn")

@export var drop_items : Array[CardData]


func drop(drop_position:Vector3, receiver:Character):
	var total_item_chance : float = 0
	var item_chances : Array = []
	for item in drop_items:
		var item_chance : Array = [item, total_item_chance]
		total_item_chance += item.get_card_drop_chance(receiver)
		item_chance.append(total_item_chance)
		
		item_chances.append(item_chance)
	
	var random_chance : int = randi_range(0, total_item_chance)
	var choosen_item : CardData = null
	for item_chance in item_chances:
		if random_chance > item_chance[1] and random_chance <= item_chance[2]:
			choosen_item = item_chance[0]
	
	if choosen_item:
		var pickupable = CARD_PICKUPABLE.instantiate()
		Global.add_child(pickupable)
		pickupable.spawn(drop_position, [choosen_item])
