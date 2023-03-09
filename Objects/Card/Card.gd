extends Resource
class_name Card

enum SUITS {
	PENTAGON, ## Heavy Defense (Health Amount)
	TRIANGLE, ## Light Defense (Move Speed)
	DIAMOND, ## Heavy Damage(Attack Damage)
	ARROW, ## Light Damage(Attack Speed)
}

## Ace is Adding an amount, Two is Adding 4 amount and subtracting an amount Jack is Learning a Skill
@export_enum("1 - Ace:1", "2 - Deuce:2", "3 - Jack:3") var value : int = 1
@export var suit : SUITS = SUITS.PENTAGON

var card_name : String = "" : get = get_card_name


func _init(new_value : int=1, new_suit : SUITS=SUITS.PENTAGON):
	value = new_value
	suit = new_suit


func get_card_name() -> String:
	if card_name == "":
		var value_to_string = ["none", "Ace", "Deuce", "Jack"]
		var suit_to_string = ["Pentagons", "Triangles", "Diamonds", "Arrows"]
		
		card_name += value_to_string[value] + " Of " + suit_to_string[suit]
	
	return card_name


func process_card(body:Character) -> void:
	if value == 1:
		pass
	
	unique_process_card(body)


func unique_process_card(body:Character) -> void:
	pass
