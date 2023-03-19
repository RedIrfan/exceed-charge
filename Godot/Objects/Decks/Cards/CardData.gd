extends Resource
class_name CardData

enum SUITS {
	PENTAGON, ## Heavy Defense (Health Amount)
	TRIANGLE, ## Light Defense (Move Speed)
	DIAMOND, ## Heavy Damage(Attack Damage)
	ARROW, ## Light Damage(Attack Speed)
	WILD,
}

## Ace is Adding an amount, Two is Adding 4 amount and subtracting an amount Jack is Learning a Skill
@export_enum("1 - Ace:1", "2 - Deuce:2", "3 - Jack:3") var value : int = 1
@export var suit : SUITS = SUITS.PENTAGON

@export_group("Unique")
@export var card_name : String = "" : get = get_card_name
@export var card_image : Texture = null : get = get_card_image
@export var card_drop_chance : int = 0


func _init(new_value : int=1, new_suit : SUITS=SUITS.PENTAGON, new_card_name : String="", new_card_image:Texture=null, new_card_drop_chance:int=0):
	value = new_value
	suit = new_suit
	
	card_name = new_card_name
	card_image = new_card_image
	card_drop_chance = new_card_drop_chance


func get_card_name() -> String:
	if card_name == "":
		card_name += value_to_string() + " Of " + suit_to_string()
	return card_name


func get_card_image() -> Texture:
	if card_image == null:
		# res://Assets/Cards/Suits/Value.png
		var img_path = "res://Assets/Cards/" + suit_to_string() + "/" + value_to_string() + ".png"
		
		card_image = load(img_path)
	return card_image


func get_card_drop_chance(_receiver:Character) -> int:
	if card_drop_chance == 0:
		match value:
			1:
				card_drop_chance = 50
			2:
				card_drop_chance = 40
			3:
				card_drop_chance = 20
	return card_drop_chance


func value_to_string() -> String:
	var string_conversions = ["none", "Ace", "Deuce", "Jack"]
	
	return string_conversions[value]


func suit_to_string()->String:
	var string_conversions = ["Pentagons", "Triangles", "Diamonds", "Arrows"]
	
	return string_conversions[suit]


func process_card(body:Character) -> void:
	var adjacent_suit_power :float = 0.0
	var opposite_suit_power :float = 0.0
	match value:
		1:
			adjacent_suit_power += 0.01
		2:
			adjacent_suit_power += 0.04
			opposite_suit_power -= 0.02
	
	var status_data : StatusData = body.status
	match suit:
		SUITS.PENTAGON:
			status_data.defense_multiplier += adjacent_suit_power
			status_data.speed_multiplier += opposite_suit_power
		SUITS.TRIANGLE:
			status_data.speed_multiplier += adjacent_suit_power
			status_data.defense_multiplier += opposite_suit_power
		SUITS.DIAMOND:
			status_data.attack_speed_multiplier += adjacent_suit_power
			status_data.attack_damage_multiplier += opposite_suit_power
		SUITS.ARROW:
			status_data.attack_damage_multiplier += adjacent_suit_power
			status_data.attack_speed_multiplier += opposite_suit_power
	
	unique_process_card(body)


func unique_process_card(_body:Character) -> void:
	pass
