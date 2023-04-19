extends Character

signal player_attacked
signal card_activated

const BLACK_SUIT_MATERIAL : Material = preload('res://Objects/Shaders/Player/Suits/BlackSuit.tres')
const FIRE_SUIT_MATERIAL : Material = preload('res://Objects/Shaders/Player/Suits/FireSuit.tres')
const WATER_SUIT_MATERIAL : Material = preload('res://Objects/Shaders/Player/Suits/WaterSuit.tres')

const CARD_PICKUPABLE = preload('res://Objects/Interactable/CardPickupable/CardPickupable.tscn')

@onready var dust_particles_left : GPUParticles3D = $Pivot/Player/Armature/GeneralSkeleton/LeftFoot/DustParticles
@onready var dust_particles_right : GPUParticles3D = $Pivot/Player/Armature/GeneralSkeleton/RightFoot/DustParticles
@onready var locking_target_area : ScanArea = $Pivot/LockingTargetArea
@onready var exceed_charge_timer : Timer = $ExceedChargeTimer
@onready var sword_model : MeshInstance3D = $Pivot/Player/Armature/GeneralSkeleton/RightHand/AlphaHilt/AlphaSword

@export var deck :DeckData
@export var status : StatusData
@export var player_model : MeshInstance3D

@onready var interact_area : Area3D = $Pivot/InteractArea

var deck_on : bool = false


func _ready():
	exceed_charge_timer.connect("timeout", _on_exceed_charge_timeout)
	
	super._ready()
	
	status.connect("element_changed", _on_element_changed)
	status.connect("passive_cards_changed", _on_passive_cards_changed)
	deck.connect("exceeded_charge", _on_exceeded_charge)


func player_attack():
	emit_signal("player_attacked")


func process_damage(damage:float):
	damage = damage / status.defense_multiplier
	super.process_damage(damage)


func lock_to_target():
	if locking_target_area.interact_list.size() > 0:
		look_at(locking_target_area.get_interactable().global_position, Vector3.UP)


func get_total_charge() -> float:
	if get_exceed_charge_suit() != CardData.SUITS.NONE:
		return exceed_charge_timer.time_left
	return deck.charge.size()


func get_exceed_charge_suit():
	return deck.exceed_charge_suit


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


func set_dust_particles(mode:bool):
	dust_particles_left.emitting = mode
	dust_particles_right.emitting = mode


func add_passive_cards(suit:CardData.SUITS, value:CardData.VALUES, amount:int=1):
	for index in amount:
		status.add_passive_card(suit, value)


func get_total_passive_card(suit:CardData.SUITS, value:CardData.VALUES) -> int:
	return status.get_total_passive_card(suit, value)


func remove_passive_cards(suit:CardData.SUITS, value:CardData.VALUES, amount:int=1):
	for index in amount:
		status.remove_passive_card(suit, value)


func use_card(card_index:int, card_data:CardData=null):
	deck.use_card(card_index, self, card_data)
	set_move_speed(SPEED)


func remove_card(card_index:int, spawn_card_mesh:bool=true):
	if spawn_card_mesh:
		var card_data :CardData= deck.get_card(card_index)
		var card_pickupable = CARD_PICKUPABLE.instantiate()
		
		Global.add_child(card_pickupable)
		card_pickupable.spawn(self.global_transform.origin + self.global_transform.basis.z * -1.5, [card_data])
	
	deck.remove_card(card_index)


func on_card_activated():
	emit_signal("card_activated")


func _on_exceeded_charge():
	exceed_charge_timer.start(deck.get_maximum_charge() - 1)


func _on_exceed_charge_timeout():
	deck.reset_charge(self)


func _on_element_changed(to_element):
	match to_element:
		StatusData.ELEMENTS.NONE:
			set_suit_material(BLACK_SUIT_MATERIAL)
		StatusData.ELEMENTS.FIRE:
			set_suit_material(FIRE_SUIT_MATERIAL)
		StatusData.ELEMENTS.WATER:
			set_suit_material(WATER_SUIT_MATERIAL)


func _on_passive_cards_changed():
	var sword_scale = 1 + (0.05 * get_total_passive_card(CardData.SUITS.DIAMOND, CardData.VALUES.THREE))
	
	sword_model.scale = Vector3(sword_scale, sword_scale, sword_scale)


func _on_hitbox_hit():
	if get_exceed_charge_suit() == CardData.SUITS.BLACKHEART:
		set_health(health + 1)
