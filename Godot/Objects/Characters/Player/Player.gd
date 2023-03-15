extends Character

signal card_activated

@export var deck :DeckData
@export var status : StatusData

@onready var pickup_area : Area3D = $Pivot/PickupArea

var deck_on : bool = false


func use_card(card_index:int):
	deck.use_card(card_index, self)


func remove_card(card_index:int):
	deck.remove_card(card_index)


func on_card_activated():
	emit_signal("card_activated")
