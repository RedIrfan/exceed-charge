extends Gui

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var level_panel : TextureRect = $Margin/HudBar/LevelPanel
@onready var level_label : Label = $Margin/HudBar/LevelPanel/Label
@onready var health_bar : TextureProgressBar = $Margin/HudBar/HealthBar
@onready var charge_bar : TextureProgressBar = $Margin/HudBar/ChargeBar

@onready var defense_percentage : Label = $Margin/HudBar/VBoxContainer/GridContainer/Defense
@onready var speed_percentage : Label = $Margin/HudBar/VBoxContainer/GridContainer/Speed
@onready var attack_damage_percentage : Label = $Margin/HudBar/VBoxContainer/GridContainer/AttackDamage
@onready var attack_speed_percentage: Label = $Margin/HudBar/VBoxContainer/GridContainer/AttackSpeed

@onready var interact_label : TextureRect = $InteractLabel

var set_up : bool = false


func _ready():
	interact_label.set_process(false)


func enter():
	super.enter()
	
	if player.get_exceed_charge_suit() == CardData.SUITS.NONE:
		charge_bar.max_value = player.deck.get_maximum_charge()
		charge_bar.value = player.get_total_charge()
	
	if player.interact_area.is_connected("interact_list_changed", _on_interact_list_changed) == false:
		player.interact_area.connect("interact_list_changed", _on_interact_list_changed)
	
	if set_up == false:
		set_up = true
		health_bar.max_value = player.HEALTH
		charge_bar.max_value = player.deck.get_maximum_charge()
		
		set_all_value()
		
		player.connect('health_changed', _on_health_changed)
		player.connect("card_activated", _on_card_activated)
		player.status.connect("element_changed", _on_element_changed)


func exit():
	if player.interact_area.is_connected("interact_list_changed", _on_interact_list_changed):
		player.interact_area.disconnect("interact_list_changed", _on_interact_list_changed)
	
	await get_tree().create_timer(0.1).timeout
	
	super.exit()


func process(_delta):
	if player.get_exceed_charge_suit() != CardData.SUITS.NONE:
		charge_bar.max_value = player.deck.get_maximum_charge() * 100
		charge_bar.value = player.get_total_charge() * 100
		
		if charge_bar.value <= 0.1:
			charge_bar.max_value = player.deck.get_maximum_charge()
			charge_bar.value = player.get_total_charge()
	
	if Input.is_action_just_pressed("action_deck"):
		gm.enter_gui("Deck")


func set_all_value():
	health_bar.value = player.health
	
	charge_bar.value = player.get_total_charge()
	level_label.set_text(str(player.deck.level))
	
	defense_percentage.set_text(_format_percentage(str(player.status.defense_multiplier)))
	speed_percentage.set_text(_format_percentage(str(player.status.speed_multiplier)))
	attack_damage_percentage.set_text(_format_percentage(str(player.status.attack_damage_multiplier)))
	attack_speed_percentage.set_text(_format_percentage(str(player.status.attack_speed_multiplier)))


func _on_health_changed(new_health):
	health_bar.value = new_health


func _on_card_activated():
	charge_bar.value = player.get_total_charge()
	level_label.set_text(str(player.deck.level))
	
	defense_percentage.set_text(_format_percentage(str(player.status.defense_multiplier)))
	speed_percentage.set_text(_format_percentage(str(player.status.speed_multiplier)))
	attack_damage_percentage.set_text(_format_percentage(str(player.status.attack_damage_multiplier)))
	attack_speed_percentage.set_text(_format_percentage(str(player.status.attack_speed_multiplier)))


func _on_interact_list_changed():
	if Global.stage_master().camera:
#		var camera : Camera3D = Global.stage_master().camera.camera3d
		var interact_area = player.interact_area
		
		interact_label.visible = false
		interact_label.set_process(false)
		if interact_area.interact_list.size() > 0:
			interact_label.start()
			interact_label.set_process(true)


func _format_percentage(text) -> String:
	return text +"%"


func _on_element_changed(to_element):
	var elements_material : Array[ShaderMaterial] = [player.BLACK_SUIT_MATERIAL, player.FIRE_SUIT_MATERIAL, null, player.WATER_SUIT_MATERIAL]
	
	level_panel.material.set_shader_parameter("colour", elements_material[to_element].get_shader_parameter('albedo'))
