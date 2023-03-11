extends Resource
class_name DeckData

@export var body : Character
@export var CHARGE : int = 5
@export var DECK_MAX_AMOUNT : int = 5
@export var deck_list : Array[CardData] = []

var limit_max_charge : int = CHARGE
var charge : int = 0


func _init(new_body:Character=null, new_charge : int=5, new_deck_max_amount : int = 5, new_deck_list:Array[CardData]=[]):
	body = new_body
	CHARGE = new_charge
	DECK_MAX_AMOUNT = new_deck_max_amount
	deck_list = new_deck_list
	
	limit_max_charge = CHARGE


func add_card(card:CardData) -> bool:
	if deck_list.size() < DECK_MAX_AMOUNT:
		deck_list.append(card)
		return true
	return false


func remove_card(card_index:int) -> bool:
	if card_index < deck_list.size():
		deck_list.remove_at(card_index)
		
		return true
	return false


func use_card(card_index:int) -> bool:
	if card_index < deck_list.size():
		if charge < limit_max_charge:
			var card = deck_list[card_index]
			card.process_card(body)
			
			charge += card.value
			if charge >= limit_max_charge:
				exceed_charge()
	return false


func exceed_charge():
	limit_max_charge -= 1
	if limit_max_charge > 0:
		charge = 0
