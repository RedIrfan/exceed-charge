extends StatePlayer

@onready var dash_timer :Timer = $DashTimer

@export var dash_speed : int = 12
@export var dash_duration : float = 0.1667
@export var stop_duration : float = 0.2
@export var dash_cooldown : float = 0.1
@export var chain_dash_max_amount : int = 0

@export_group("Attack", "attack_")
@export var attack_hitbox : Hitbox
@export var attack_damage : int

@export_group("Exceed Charge", "exceed_")
@export var exceed_dash_speed : int = 25
@export var exceed_dash_distance : float = 2.5

var dash_direction : Vector2 = Vector2.ZERO

var chain_dash_amount : int = 0
var dashing : bool = false
var dash_distance : float = 1.667


func _ready():
	dash_distance = dash_speed * dash_duration


func enter(_msg=[]):
	body.connect_to_animation_timer(_on_animation_timeout)
	
	var four_card_amount = body.get_total_passive_card(CardData.SUITS.TRIANGLE, CardData.VALUES.FOUR)
	var distance = dash_distance
	var speed = dash_speed
	
	if body.get_exceed_charge_suit() == CardData.SUITS.TRIANGLE:
		four_card_amount += 1
		distance = exceed_dash_distance
		speed = exceed_dash_speed
		body.set_collision_layer_value(2, false)
		body.set_collision_mask_value(2, false)
	
	chain_dash_max_amount = body.get_total_passive_card(CardData.SUITS.TRIANGLE, CardData.VALUES.THREE)
	if four_card_amount > 0 or body.get_exceed_charge_suit() == CardData.SUITS.TRIANGLE:
		attack_hitbox.set_damage(body.get_attack_damage(attack_damage * four_card_amount))
		if four_card_amount > 0:
			body.remove_passive_cards(CardData.SUITS.TRIANGLE, CardData.VALUES.FOUR)
	
	set_move_speed(speed)
	dashing = true
	
	if body.speed != speed:
		dash_duration = distance / body.speed
	
	dash_direction = get_direction()
	_play_dash_animation()


func exit():
	body.set_collision_layer_value(2, true)
	body.set_collision_mask_value(2, true)
	chain_dash_amount = 0
	body.set_dust_particles(false)
	body.disconnect_from_animation_timer(_on_animation_timeout)
	
	reset_speed()
	reset_direction()
	dash_timer.start(dash_cooldown)


func physics_process(_delta):
#	look_at_mouse()
	if check_dash() and chain_dash_amount < chain_dash_max_amount:
		body.remove_passive_cards(CardData.SUITS.TRIANGLE, CardData.VALUES.THREE)
#		chain_dash_amount += 1
		look_at_mouse(1)
		enter()
	if check_hurt():
		if dashing:
			body.hurt_data = null
		else:
			fsm.enter_state("Hurt")
	if dashing == true:
		body.set_dust_particles(true)
		
		if check_primary_attack():
			fsm.enter_state("PrimaryAttackMaster", [get_relative_direction_name(dash_direction)])
		apply_direction(dash_direction)


func _play_dash_animation():
	var animation_name = "Dash"
	
	animation_name += get_relative_direction_name(dash_direction)
	
	if animation_name != "Dash":
		body.play_animation(animation_name, dash_duration, true)


func _on_animation_timeout():
	if dashing:
		attack_hitbox.set_damage(0)
		dashing = false
		body.set_dust_particles(false)
		reset_speed()
		reset_direction()
		body.play_animation("Idle", stop_duration)
	else:
		fsm.enter_state("Idle")
