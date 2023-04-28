extends Resource
class_name StatusData

enum ELEMENTS{
	NONE,
	FIRE,
	WIND,
	WATER,
	EARTH,
	VOID
}

signal passive_cards_changed
signal active_cards_changed
signal element_changed(to_element)

@export_group("Multiplier")
@export var DEFENSE_MULTIPLIER : float = 1.0
@export var SPEED_MULTIPLIER : float = 1.0
@export var ATTACK_DAMAGE_MULTIPLIER : float = 1.0
@export var ATTACK_SPEED_MULTIPLIER : float = 1.0
@export var LUCK_MULTIPLIER : float = 1.0

@export_group("Wild")
@export var element : ELEMENTS = ELEMENTS.NONE : set = set_element
@export var primary_active_card : CardData = null
@export var secondary_active_card : CardData = null
@export var _passive_cards : Array[CardData] = []

var defense_multiplier : float = 1.0
var speed_multiplier : float = 1.0
var attack_damage_multiplier : float = 1.0
var attack_speed_multiplier : float = 1.0
var luck_multiplier : float = 1.0

var primary_active_card_charge : int = 0
var secondary_active_card_charge : int = 0
var passive_cards : Array[Array]


func _init(new_defense:float=1.0,new_speed:float=1.0,new_damage:float=1.0,new_atk_speed:float=1.0,new_luck:float=1.0,new_element:ELEMENTS=ELEMENTS.NONE,new_primary_active:CardData=null, new_secondary_active:CardData=null, new_passive_cards:Array[CardData]=[]):
	DEFENSE_MULTIPLIER = new_defense
	SPEED_MULTIPLIER = new_speed
	ATTACK_DAMAGE_MULTIPLIER = new_damage
	ATTACK_SPEED_MULTIPLIER = new_atk_speed
	LUCK_MULTIPLIER = new_luck
	_passive_cards = new_passive_cards
	
	restart()
	
	element = new_element
	primary_active_card = new_primary_active
	secondary_active_card = new_secondary_active


func restart():
	defense_multiplier = DEFENSE_MULTIPLIER
	speed_multiplier = SPEED_MULTIPLIER
	attack_damage_multiplier = ATTACK_DAMAGE_MULTIPLIER
	attack_speed_multiplier = ATTACK_SPEED_MULTIPLIER
	luck_multiplier = LUCK_MULTIPLIER
	
	element = ELEMENTS.NONE
	primary_active_card = null
	secondary_active_card = null
	
	for card in _passive_cards:
		add_passive_card(card.suit, card.value)


func add_active_card(mode:int, card:CardData, charge:int):
	if mode == 1:
		if primary_active_card == null or primary_active_card.suit != card.suit:
			primary_active_card = card
			primary_active_card_charge = charge
		elif primary_active_card.suit == card.suit:
			primary_active_card_charge += charge
	else:
		if secondary_active_card == null or secondary_active_card.suit != card.suit:
			secondary_active_card = card
			secondary_active_card_charge = charge
		elif secondary_active_card.suit == card.suit:
			secondary_active_card_charge += charge
	emit_signal("active_cards_changed")


func remove_active_charge(mode:int, amount:int):
	if mode == 1:
		primary_active_card_charge -= amount
		if primary_active_card_charge <= 0:
			primary_active_card = null
	else:
		secondary_active_card_charge -= amount
		if secondary_active_card_charge <= 0:
			secondary_active_card = null
	emit_signal("active_cards_changed")


func set_element(new_element:ELEMENTS):
	element = new_element
	emit_signal("element_changed", new_element)


func get_total_passive_card(suit:CardData.SUITS, value:CardData.VALUES) -> int:
	var amount = passive_cards.count([suit, value])
	return amount


func add_passive_card(suit:CardData.SUITS, value:CardData.VALUES):
	passive_cards.append([suit, value])
	emit_signal("passive_cards_changed")


func remove_passive_card(suit:CardData.SUITS, value:CardData.VALUES):
	passive_cards.erase([suit, value])
	emit_signal("passive_cards_changed")
