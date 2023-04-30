extends Effect

const PENTAGON_SHOCKWAVE = preload("res://Objects/Effects/Attacks/Player/SkillGroundPoundEffect/PentagonShockwave/PentagonShockwave.tscn")
const SHIELD_MESH = preload('res://Objects/Effects/ShieldCircle/ShieldMesh.tscn')
const AGILITY_SHIELD_MESH = preload("res://Objects/Effects/ShieldCircle/AgilityShieldMesh.tscn")

@export var speed : float = 1
@export var defense_shield_distance : Vector3 = Vector3(0, 1.3, 1.5)
@export var agility_shield_distance : Vector3 = Vector3(0, 1.3, 1)

@onready var pivot : Node3D = $Pivot
@onready var shield_regeneration_timer : Timer = $ShieldRegenerationTimer

var player : Character
var defense_shields : Dictionary
var agility_shields : Dictionary

var shield_regeneration_turn : int = 0
var shield_regeneration_duration : float = 0


func _ready():
	await Global.root_scene().ready
	
	player = Global.root_scene().player
	
	player.status.connect("passive_cards_changed", _on_passive_changed)
	player.deck.connect("exceeded_charge", _on_exceeded_charge)
	player.connect("exceed_charge_timeout", _on_exceed_charge_timeout)


func _physics_process(delta):
	if player:
		self.global_position = player.global_position
		pivot.rotate(Vector3.UP, speed * delta)


func _on_passive_changed():
	var shield_amount = player.get_total_passive_card(CardData.SUITS.PENTAGON, CardData.VALUES.DEUCE)
	var agility_shield_amount = player.get_total_passive_card(CardData.SUITS.TRIANGLE, CardData.VALUES.DEUCE)
	
	defense_shields = spawn_shields(shield_amount, SHIELD_MESH, defense_shields, "Defense", defense_shield_distance)
	agility_shields = spawn_shields(agility_shield_amount, AGILITY_SHIELD_MESH, agility_shields, "Agility", agility_shield_distance)


func spawn_shields(amount:int, mesh:PackedScene, shield_collection:Dictionary, object_name_prefix:String, shield_distance:Vector3):
	if amount < shield_collection.size():
		for object in shield_collection:
			shield_collection[object].visible = false
	if amount > 0:
		var rotation_interval = 360.0 / amount
		
		for index in amount:
			var object : MeshInstance3D
			var object_name = object_name_prefix + str(index)
			var object_rotation = deg_to_rad(rotation_interval * index )
			var object_position = shield_distance.rotated(Vector3.UP, object_rotation )
			
			if shield_collection.has(object_name):
				object = shield_collection[object_name]
				object.visible = true
			else:
				object = mesh.instantiate()
				pivot.add_child(object)
				
				shield_collection[object_name] = object
			
			object.name = object_name
			object.rotation.y = object_rotation
			object.position = object_position
		
	return shield_collection


func _on_exceeded_charge():
	var suit = player.get_exceed_charge_suit()
	if suit == CardData.SUITS.PENTAGON or suit == CardData.SUITS.TRIANGLE or suit == CardData.SUITS.DIAMOND:
		if player.get_total_passive_card(suit, CardData.VALUES.DEUCE) < 5:
			player.add_passive_cards(suit, CardData.VALUES.DEUCE, 5)
		
		if suit != CardData.SUITS.DIAMOND:
			shield_regeneration_duration = 1
	elif suit == CardData.SUITS.HEART or suit == CardData.SUITS.BLACKHEART:
		shield_regeneration_duration = 1
		if suit == CardData.SUITS.BLACKHEART:
			player.maximum_health -= 5
		if suit == CardData.SUITS.HEART:
			player.maximum_health += 2
	
	shield_regeneration_turn = 0
	if shield_regeneration_duration > 0:
		shield_regeneration_timer.start(shield_regeneration_duration)


func _on_exceed_charge_timeout():
	if player.get_exceed_charge_suit() == CardData.SUITS.DIAMOND:
		player.remove_passive_cards(CardData.SUITS.DIAMOND, CardData.VALUES.DEUCE, 5)


func _on_shield_regeneration_timer_timeout():
	shield_regeneration_turn += 1
	
	var suit = player.get_exceed_charge_suit()
	if suit != CardData.SUITS.NONE:
		if suit == CardData.SUITS.PENTAGON or suit == CardData.SUITS.TRIANGLE:
			if player.get_total_passive_card(suit, CardData.VALUES.DEUCE) < 5:
				player.add_passive_cards(suit, CardData.VALUES.DEUCE, 1)
			
			if suit == CardData.SUITS.PENTAGON and shield_regeneration_turn >= 2:
				var shockwave = PENTAGON_SHOCKWAVE.instantiate()
				shockwave.spawn(self.global_position, {"body" : player})
				
				shield_regeneration_turn = 0
		
		if suit == CardData.SUITS.HEART:
			player.health += 3
		if suit == CardData.SUITS.BLACKHEART:
			player.health += 5
		
		shield_regeneration_timer.start(shield_regeneration_duration)
