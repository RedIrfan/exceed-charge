extends Character

signal card_activated

const CARD_PICKUPABLE = preload('res://Objects/Interactable/CardPickupable/CardPickupable.tscn')

@export var deck :DeckData
@export var status : StatusData

@onready var interact_area : Area3D = $Pivot/InteractArea

var deck_on : bool = false


func use_card(card_index:int):
	deck.use_card(card_index, self)


func remove_card(card_index:int):
	var card_data :CardData= deck.get_card(card_index)
	var card_pickupable = CARD_PICKUPABLE.instantiate()
	
	Global.add_child(card_pickupable)
	card_pickupable.spawn(self.global_transform.origin + self.global_transform.basis.z * -1.5, [card_data])
	
	deck.remove_card(card_index)


func on_card_activated():
	emit_signal("card_activated")
