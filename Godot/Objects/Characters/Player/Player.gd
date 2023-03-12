extends Character

@export var deck :DeckData
@export var status : StatusData

var deck_on : bool = false


func use_card(card_index:int):
	deck.use_card(card_index, self)
