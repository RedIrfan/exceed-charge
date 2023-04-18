class_name PlayerActionOr
extends ActionOr

@export_category("Condition")

@export_group("Passive Card", "condition_passive_")
@export var condition_passive_card : CardData
@export var condition_passive_action_target : int

@export_group("Exceed Charge", "condition_exceed_")
@export var condition_exceed_suit : CardData.SUITS
@export var condition_exceed_action_target : int


func get_chosen(body : Character) -> ActionData:
	var chosen : int = 0
	if condition_exceed_suit != CardData.SUITS.NONE:
		if body.get_exceed_charge_suit() == condition_exceed_suit:
			chosen = condition_exceed_action_target
	if condition_passive_card != null:
		if body.get_total_passive_card(condition_passive_card.suit, condition_passive_card.value) > 0:
			body.remove_passive_cards(condition_passive_card.suit, condition_passive_card.value, 1)
			chosen = condition_passive_action_target
	
	return null if chosen == 0 else possible_actions[chosen - 1]
