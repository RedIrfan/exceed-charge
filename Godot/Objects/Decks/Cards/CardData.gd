extends Resource
class_name CardData

const SOUND_HEAL : AudioStreamWAV = preload('res://Assets/SFX/Game/Player/Heal.wav')
const SOUND_BLACK_HEAL :AudioStreamWAV = preload('res://Assets/SFX/Game/Player/BlackHeal.wav')

enum SUITS {
	NONE,
	PENTAGON, ## Heavy Defense (Health Amount)
	TRIANGLE, ## Light Defense (Move Speed)
	DIAMOND, ## Heavy Damage(Attack Damage)
	ARROW, ## Light Damage(Attack Speed)
	HEART,
	BLACKHEART,
	WILD,
}

enum VALUES {
	NONE,
	ACE,
	DEUCE,
	THREE,
	FOUR,
	JACK
}

## Ace is Adding an amount, Two is Adding 4 amount and subtracting an amount Jack is Learning a Skill
@export var value : VALUES = VALUES.ACE
@export var suit : SUITS = SUITS.PENTAGON

@export_group("Unique")
@export var card_name : String = "" : get = get_card_name
@export var card_image : Texture = null : get = get_card_image
@export var card_drop_chance : int = 0


func _init(new_value : VALUES=VALUES.ACE, new_suit : SUITS=SUITS.PENTAGON, new_card_name : String="", new_card_image:Texture=null, new_card_drop_chance:int=0):
	value = new_value
	suit = new_suit
	
	card_name = new_card_name
	card_image = new_card_image
	card_drop_chance = new_card_drop_chance


func get_card_name() -> String:
	if card_name == "":
		@warning_ignore("static_called_on_instance")
		card_name += value_to_string(value) + " Of " + suit_to_string(suit)
	return card_name


func get_card_image() -> Texture:
	if card_image == null:
		# res://Assets/Cards/Suits/Value.png
		@warning_ignore("static_called_on_instance")
		var img_path = "res://Assets/Cards/" + suit_to_string(suit) + "/" + value_to_string(value) + ".png"
		
		card_image = load(img_path)
	return card_image


func get_card_drop_chance(_receiver:Character) -> int:
	if card_drop_chance == 0:
		match value:
			VALUES.ACE:
				card_drop_chance = 50
			VALUES.DEUCE:
				card_drop_chance = 40
			VALUES.THREE:
				card_drop_chance = 30
			VALUES.JACK:
				card_drop_chance = 20
	return card_drop_chance


static func value_to_string(val) -> String:
	var string_conversions = ["none", "Ace", "Deuce", "Three", "Four", "Jack"]
	
	return string_conversions[val]


static func suit_to_string(int_suit)->String:
	var string_conversions = ["none", "Pentagons", "Triangles", "Diamonds", "Arrows", "Hearts", "Black Hearts", "Wilds"]
	
	return string_conversions[int_suit]


func process_card(body:Character) -> void:
	var adjacent_suit_power :float = 0.0
	var opposite_suit_power :float = 0.0
	var active_card_mode : int = 0
	var charge : int = 3
	var extra_attribute_name : String = ""
	
	match value:
		VALUES.ACE:
			adjacent_suit_power += 0.01
		VALUES.DEUCE:
			adjacent_suit_power += 0.03
			opposite_suit_power -= 0.01
	
	var status_data : StatusData = body.status
	match suit:
		SUITS.PENTAGON:
			status_data.defense_multiplier += adjacent_suit_power
			status_data.speed_multiplier += opposite_suit_power
			
			active_card_mode = 1
		SUITS.TRIANGLE:
			status_data.speed_multiplier += adjacent_suit_power
			status_data.defense_multiplier += opposite_suit_power
			
			active_card_mode = 1
		SUITS.DIAMOND:
			if value == VALUES.THREE:
				opposite_suit_power = -0.01
			status_data.attack_damage_multiplier += adjacent_suit_power
			status_data.attack_speed_multiplier += opposite_suit_power
			
			active_card_mode = 2
		SUITS.ARROW:
			status_data.attack_speed_multiplier += adjacent_suit_power
			status_data.attack_damage_multiplier += opposite_suit_power
			
			active_card_mode = 2
		SUITS.HEART:
			var play_sound : bool = false
			match value:
				VALUES.ACE:
					body.health += 5
					play_sound = true
				VALUES.DEUCE:
					body.maximum_health += 1
					body.health += 3
					play_sound = true
			active_card_mode = 1
			
			if play_sound:
				Global.play_sound(SOUND_HEAL)
		SUITS.BLACKHEART:
			var play_sound : bool = false
			match value:
				VALUES.ACE:
					body.maximum_health -= 1
					body.health += 10
					play_sound = true
				VALUES.DEUCE:
					body.maximum_health -= 2
					body.health += 25
					play_sound = true
			active_card_mode = 1
			
			if play_sound:
				Global.play_sound(SOUND_BLACK_HEAL)
	
	match value:
		VALUES.JACK:
			status_data.add_active_card(active_card_mode, self, charge)
		_:
			status_data.add_passive_card(suit, value)
	
	unique_process_card(body)


func unique_process_card(_body:Character) -> void:
	pass
