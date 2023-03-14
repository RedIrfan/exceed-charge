extends Character

signal card_activated

@export var deck :DeckData
@export var status : StatusData

var deck_on : bool = false


func use_card(card_index:int):
	deck.use_card(card_index, self)


func on_card_activated():
	emit_signal("card_activated")
