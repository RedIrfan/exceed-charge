extends Resource
class_name DeckData

const SOUND_EXCEED_CHARGE = preload("res://Assets/SFX/Deck/ExceedCharge.wav")

signal exceeded_charge

@export var CHARGE : int = 3
@export var DECK_MAX_AMOUNT : int = 5
@export var deck_list : Array[CardData] = []

var level : int = 1
var charge : Array[CardData.SUITS] = []
var normal_status : Array = []

var exceed_charge_suit : CardData.SUITS = CardData.SUITS.NONE


func _init(new_charge : int=3, new_deck_max_amount : int = 5, new_deck_list:Array[CardData]=[]):
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


func reset_charge(body):
	charge.clear()
	
	if exceed_charge_suit:
		body.status.defense_multiplier = normal_status[0]
		body.status.speed_multiplier = normal_status[1]
		body.status.attack_damage_multiplier = normal_status[2]
		body.status.attack_speed_multiplier = normal_status[3]
		body.status.passive_cards = normal_status[4]
		
		exceed_charge_suit = CardData.SUITS.NONE


func exceed_charge(body):
	var status : StatusData = body.status
	normal_status = [status.defense_multiplier, status.speed_multiplier, status.attack_damage_multiplier, status.attack_speed_multiplier, status.passive_cards]
	
	var exceed_types : Array[int] = [0]
	exceed_types.resize(CardData.SUITS.size())
	for charge_type in charge:
		exceed_types[charge_type] += 1
	
	@warning_ignore("int_as_enum_without_cast")
	exceed_charge_suit = exceed_types.find(exceed_types.max())
	match exceed_charge_suit:
		CardData.SUITS.PENTAGON:
			pass
		CardData.SUITS.TRIANGLE:
			pass
		CardData.SUITS.DIAMOND:
			pass
		CardData.SUITS.ARROW:
			pass
	
	var soundfx = SoundFx.new()
	soundfx.spawn(Vector3.ZERO, {"audio" : SOUND_EXCEED_CHARGE})
	
	level += 1
	
	emit_signal("exceeded_charge")


func get_maximum_charge() -> int:
	return CHARGE + (level-1)
