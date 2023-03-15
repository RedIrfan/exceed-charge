extends Gui

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var level_label : Label = $Margin/HudBar/LevelLabel
@onready var health_bar : TextureProgressBar = $Margin/HudBar/HealthBar
@onready var charge_bar : TextureProgressBar = $Margin/HudBar/ChargeBar

@onready var defense_percentage : Label = $Margin/HudBar/HBoxContainer/Defense/Label
@onready var speed_percentage : Label = $Margin/HudBar/HBoxContainer/Speed/Label
@onready var attack_damage_percentage : Label = $Margin/HudBar/HBoxContainer/AttackDamage/Label
@onready var attack_speed_percentage: Label = $Margin/HudBar/HBoxContainer/AttackSpeed/Label

@onready var pickup_label : Label = $PickupLabel

var set_up : bool = false


func _ready():
	pickup_label.set_process(false)



func enter():
	super.enter()
	
	player.pickup_area.connect("pickup_list_changed", _on_pickup_list_changed)
	
	if set_up == false:
		set_up = true
		health_bar.max_value = player.HEALTH
		charge_bar.max_value = player.deck.CHARGE
		
		set_all_value()
		
		player.connect('health_changed', _on_health_changed)
		player.connect("card_activated", _on_card_activated)


func exit():
	player.pickup_area.disconnect("pickup_list_changed", _on_pickup_list_changed)
	
	await get_tree().create_timer(0.1).timeout
	
	super.exit()


func process(_delta):
	if Input.is_action_just_pressed("action_deck"):
		gm.enter_gui("Deck")


func set_all_value():
	health_bar.value = player.health
	
	charge_bar.value = player.deck.charge.size()
	level_label.set_text(str(player.deck.level))
	
	defense_percentage.set_text(_format_percentage(str(player.status.defense_multiplier)))
	speed_percentage.set_text(_format_percentage(str(player.status.speed_multiplier)))
	attack_damage_percentage.set_text(_format_percentage(str(player.status.attack_damage_multiplier)))
	attack_speed_percentage.set_text(_format_percentage(str(player.status.attack_speed_multiplier)))


func _on_health_changed(new_health):
	health_bar.value = new_health


func _on_card_activated():
	charge_bar.value = player.deck.charge.size()
	level_label.set_text(str(player.deck.level))
	
	defense_percentage.set_text(_format_percentage(str(player.status.defense_multiplier)))
	speed_percentage.set_text(_format_percentage(str(player.status.speed_multiplier)))
	attack_damage_percentage.set_text(_format_percentage(str(player.status.attack_damage_multiplier)))
	attack_speed_percentage.set_text(_format_percentage(str(player.status.attack_speed_multiplier)))


func _on_pickup_list_changed():
	if Global.root_scene() is StageMaster:
		if Global.stage_master().camera:
			var camera : Camera3D = Global.stage_master().camera.camera3d
			var pickup_area = player.pickup_area
			
			pickup_label.visible = false
			pickup_label.set_process(false)
			if pickup_area.pickup_list.size() > 0:
				pickup_label.pickupable = pickup_area.get_pickupable()
				
				pickup_label.move_to_target_position()
				pickup_label.set_process(true)
				pickup_label.visible = true


func _format_percentage(text) -> String:
	return text +"%"
