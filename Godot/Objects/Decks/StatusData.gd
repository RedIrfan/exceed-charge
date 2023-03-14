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

@export_group("Multiplier")
@export var defense_multiplier : float = 1.0
@export var speed_multiplier : float = 1.0
@export var attack_damage_multiplier : float = 1.0
@export var attack_speed_multiplier : float = 1.0
@export var luck_multiplier : float = 1.0

@export_group("Wild")
@export var element : ELEMENTS = ELEMENTS.NONE
@export var active_card : CardData = null


func _init(new_defense:float=1.0,new_speed:float=1.0,new_damage:float=1.0,new_atk_speed:float=1.0,new_luck:float=1.0,new_element:ELEMENTS=ELEMENTS.NONE,new_active:CardData=null):
	defense_multiplier = new_defense
	speed_multiplier = new_speed
	attack_damage_multiplier = new_damage
	attack_speed_multiplier = new_speed
	luck_multiplier = new_luck
	element = new_element
	active_card = new_active
