class_name PlayerActionOrConditionData
extends ActionOrConditionData

@export_enum("Passive Card:0", "Exceed Charge:1") var mode : int
@export var value : CardData.VALUES
@export var suit : CardData.SUITS


func get_condition(body:Character, _params=[]):
	if mode == 1 and body.get_exceed_charge_suit() == suit:
		return true
	elif body.get_total_passive_card(suit, value) > 0:
		body.remove_passive_cards(suit, value, 1)
		return true
	
	return false
