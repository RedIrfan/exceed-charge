extends Control

@onready var active_mode_prompt : TextureRect = $ActiveModePrompt

@onready var primary_card : TextureRect = $HBoxContainer/PrimaryActiveCard
@onready var primary_prompt : TextureRect = $HBoxContainer/PrimaryActiveCard/ActivatePrompt
@onready var primary_pip : TextureRect = $HBoxContainer/PrimaryActiveCard/SuitPip
@onready var primary_charge : TextureProgressBar = $HBoxContainer/PrimaryActiveCard/CardChargeBar

@onready var secondary_card : TextureRect = $HBoxContainer/SecondaryActiveCard
@onready var secondary_prompt : TextureRect = $HBoxContainer/SecondaryActiveCard/ActivatePrompt
@onready var secondary_pip : TextureRect = $HBoxContainer/SecondaryActiveCard/SuitPip
@onready var secondary_charge : TextureProgressBar = $HBoxContainer/SecondaryActiveCard/CardChargeBar

var player

var last_primary_card : CardData = null
var last_secondary_card : CardData = null


func _ready():
	await Global.root_scene().ready
	
	player = Global.root_scene().player
	
	player.status.connect("active_cards_changed", _on_active_cards_changed)


func _process(_delta):
	active_mode_prompt.visible = ! Input.is_action_pressed("action_skill")
	primary_prompt.visible = ! active_mode_prompt.visible
	secondary_prompt.visible = ! active_mode_prompt.visible


func _on_active_cards_changed():
	var status : StatusData = player.status
	
	set_active_card(status.primary_active_card, status.primary_active_card_charge, primary_card, primary_pip, primary_charge, 0)
	set_active_card(status.secondary_active_card, status.secondary_active_card_charge, secondary_card, secondary_pip, secondary_charge, 1)
	
	self.visible = last_primary_card != null or last_secondary_card != null


func set_active_card(status_active_card:CardData, status_active_card_charge:int, active_card:TextureRect, active_card_pip:TextureRect, active_card_charge:TextureProgressBar, mode:int):
	var last_active_cards = [last_primary_card, last_secondary_card]
	
	if status_active_card != null:
		if status_active_card_charge > active_card_charge.max_value and status_active_card != last_primary_card:
			active_card_charge.max_value = status_active_card_charge
		last_active_cards[mode] = status_active_card
		
		active_card.visible = true
		active_card_pip.set_texture(get_pip_texture(status_active_card.suit))
		active_card_charge.value = status_active_card_charge
	else:
		active_card.visible = false
		last_active_cards[mode] = null
	
	last_primary_card = last_active_cards[0]
	last_secondary_card = last_active_cards[1]


func get_pip_texture(card_suit) -> Texture:
	var pip_texture = load("res://Assets/Hud/Cards/PassiveCards/" + CardData.suit_to_string(card_suit) + "/Ace.png")
	return pip_texture
