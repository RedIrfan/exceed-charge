class_name PlayerActionOr
extends ActionOr

@export_group("Condition", "condition_")
@export var condition_passive_card : CardData


func get_chosen(body : Character) -> bool:
	var chosen : bool = false
	if condition_passive_card != null:
		if body.get_total_passive_card(condition_passive_card.suit, condition_passive_card.value) > 0:
			body.remove_passive_cards(condition_passive_card.suit, condition_passive_card.value, 1)
			chosen = true
	
	return chosen
