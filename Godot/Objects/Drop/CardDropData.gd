extends DropData
class_name CardDropData

@export_group("Only this is used")
@export var drop_cards : Array[CardData]


const CARD_PICKUPABLE = preload("res://Objects/Pickupable/CardPickupable/CardPickupable.tscn")


func get_drop_items():
	return drop_cards


func choose_item(choosen_item, drop_position:Vector3):
	var pickupable = CARD_PICKUPABLE.instantiate()
	Global.add_child(pickupable)
	pickupable.spawn(drop_position, [choosen_item])


func get_item_chance(item, receiver) -> float:
	return item.get_card_drop_chance(receiver)
