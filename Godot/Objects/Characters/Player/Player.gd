extends Character

signal card_activated

const BLACK_SUIT_MATERIAL : Material = preload('res://Objects/Shaders/Player/Suits/BlackSuit.tres')
const FIRE_SUIT_MATERIAL : Material = preload('res://Objects/Shaders/Player/Suits/FireSuit.tres')

const CARD_PICKUPABLE = preload('res://Objects/Interactable/CardPickupable/CardPickupable.tscn')

@export var deck :DeckData
@export var status : StatusData
@export var player_model : MeshInstance3D

@onready var interact_area : Area3D = $Pivot/InteractArea

var deck_on : bool = false


func _ready():
	super._ready()
	
	status.connect("element_changed", _on_element_changed)


func process_damage(damage:float):
	damage = damage / status.defense_multiplier
	super.process_damage(damage)


func get_attack_damage(damage:float) -> float:
	damage = damage + (log(status.attack_damage_multiplier) / log(1.5))
	return damage


func get_attack_speed_calculation() -> float:
	return log(status.attack_speed_multiplier) / log(2)


func set_move_speed(new_speed:float):
	speed = new_speed + (log(status.speed_multiplier) / log(2))


func set_move_attack_speed(new_speed:float):
	speed = new_speed + get_attack_speed_calculation()


func set_suit_material(material:Material):
	player_model.set_surface_override_material(0, material)


func use_card(card_index:int):
	deck.use_card(card_index, self)
	set_move_speed(SPEED)


func remove_card(card_index:int):
	var card_data :CardData= deck.get_card(card_index)
	var card_pickupable = CARD_PICKUPABLE.instantiate()
	
	Global.add_child(card_pickupable)
	card_pickupable.spawn(self.global_transform.origin + self.global_transform.basis.z * -1.5, [card_data])
	
	deck.remove_card(card_index)


func on_card_activated():
	emit_signal("card_activated")


func _on_element_changed(to_element):
	match to_element:
		StatusData.ELEMENTS.NONE:
			set_suit_material(BLACK_SUIT_MATERIAL)
		StatusData.ELEMENTS.FIRE:
			set_suit_material(FIRE_SUIT_MATERIAL)
