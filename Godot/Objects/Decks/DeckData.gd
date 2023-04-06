extends Resource
class_name DeckData

const SOUND_EXCEED_CHARGE = preload("res://Assets/SFX/Deck/ExceedCharge.wav")

@export var CHARGE : int = 6
@export var DECK_MAX_AMOUNT : int = 5
@export var deck_list : Array[CardData] = []

var level : int = 0
var charge : Array[CardData.SUITS] = []


func _init(new_body:Character=null, new_charge : int=10, new_deck_max_amount : int = 5, new_deck_list:Array[CardData]=[]):
	CHARGE = new_charge
	DECK_MAX_AMOUNT = new_deck_max_amount
	deck_list = new_deck_list


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


func use_card(card_index:int, body:Character, card_data:CardData=null) -> bool:
	if card_index < deck_list.size() or card_data != null:
		if charge.size() < get_maximum_charge():
			var card :CardData
			if card_data != null:
				card = card_data
			else:
				card = deck_list[card_index]
				remove_card(card_index)
			
			card.process_card(body)
			
			for index in range(0, card.value):
				charge.append(card.suit)
			
			if charge.size() >= get_maximum_charge():
				exceed_charge(body)
			
			body.on_card_activated()
	return false


func get_card(card_index:int) -> CardData:
	if card_index < deck_list.size():
		return deck_list[card_index]
	return null


func exceed_charge(body):
	var exceed_types : Array = [0,0,0,0,0]
	for charge_type in charge:
		exceed_types[charge_type] += 1
	
	var exceed_type = exceed_types.find(exceed_types.max())
	
	match exceed_type:
		CardData.SUITS.PENTAGON:
			body.set_attribute("defense_shield_amount", 5)
		CardData.SUITS.TRIANGLE:
			body.set_attribute("agility_shield_amount", 5)
	
	var soundfx = SoundFx.new()
	soundfx.spawn(Vector3.ZERO, {"audio" : SOUND_EXCEED_CHARGE})
	
	level += 1
	if get_maximum_charge() > 0:
		charge.clear()


func get_maximum_charge() -> int:
	return CHARGE + level
