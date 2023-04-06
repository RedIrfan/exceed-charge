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

signal extra_attributes_changed
signal element_changed(to_element)

@export_group("Multiplier")
@export var defense_multiplier : float = 1.0
@export var speed_multiplier : float = 1.0
@export var attack_damage_multiplier : float = 1.0
@export var attack_speed_multiplier : float = 1.0
@export var luck_multiplier : float = 1.0

@export_group("Wild")
@export var element : ELEMENTS = ELEMENTS.NONE : set = set_element
@export var primary_active_card : CardData = null
@export var secondary_active_card : CardData = null
@export var extra_attributes : Dictionary = {}


func _init(new_defense:float=1.0,new_speed:float=1.0,new_damage:float=1.0,new_atk_speed:float=1.0,new_luck:float=1.0,new_element:ELEMENTS=ELEMENTS.NONE,new_primary_active:CardData=null, new_secondary_active:CardData=null):
	defense_multiplier = new_defense
	speed_multiplier = new_speed
	attack_damage_multiplier = new_damage
	attack_speed_multiplier = new_atk_speed
	luck_multiplier = new_luck
	element = new_element
	primary_active_card = new_primary_active
	secondary_active_card = new_secondary_active


func set_element(new_element:ELEMENTS):
	element = new_element
	emit_signal("element_changed", new_element)


func set_extra_attribute(attribute_name, attribute_value):
	extra_attributes[attribute_name] = attribute_value
	emit_signal("extra_attributes_changed")


func get_extra_attribute(attribute_name):
	if extra_attributes.has(attribute_name):
		return extra_attributes[attribute_name]
	return null
