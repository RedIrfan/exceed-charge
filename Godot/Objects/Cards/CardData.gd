extends Resource
class_name CardData

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
var card_image : Texture = null : get = get_card_image


func _init(new_value : int=1, new_suit : SUITS=SUITS.PENTAGON):
	value = new_value
	suit = new_suit


func get_card_name() -> String:
	if card_name == "":
		var suit_to_string = ["Pentagons", "Triangles", "Diamonds", "Arrows"]
		
		card_name += value_to_string() + " Of " + suit_to_string[suit]
	return card_name


func get_card_image() -> Texture:
	if card_image == null:
		# res://Assets/Cards/Suits/Value.png
		card_image = load("res://Assets/Cards/" + suit_to_string() + "/" + value_to_string() + ".png")
	return card_image


func value_to_string() -> String:
	var string_conversions = ["none", "Ace", "Deuce", "Jack"]
	
	return string_conversions[value]


func suit_to_string()->String:
	var string_conversions = ["Pentagons", "Triangles", "Diamonds", "Arrows"]
	
	return string_conversions[suit]


func process_card(body:Character) -> void:
	if value == 1:
		pass
	
	unique_process_card(body)


func unique_process_card(body:Character) -> void:
	pass
