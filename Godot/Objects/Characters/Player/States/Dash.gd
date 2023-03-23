extends StatePlayer

@onready var dash_timer :Timer = $DashTimer

@export var dash_speed : int = 12
@export var dash_duration : float = 0.1667
@export var stop_duration : float = 0.2
@export var dash_cooldown : float = 0.05
@export var chain_dash_max_amount : int = 0

var dash_direction : Vector2 = Vector2.ZERO

var chain_dash_amount : int = 0
var dashing : bool = false
var dash_distance : float = 1.667


func _ready():
	dash_distance = dash_speed * dash_duration


func enter(_msg=[]):
	body.connect_to_animation_timer(_on_animation_timeout)
	set_move_speed(dash_speed)
	dashing = true
	
	if body.speed != dash_speed:
		dash_duration = dash_distance / body.speed
	
	dash_direction = get_direction()
	_play_dash_animation()


func exit():
	chain_dash_amount = 0
	body.set_dust_particles(false)
	body.disconnect_from_animation_timer(_on_animation_timeout)
	
	reset_speed()
	reset_direction()
	dash_timer.start(dash_cooldown)


func physics_process(_delta):
#	look_at_mouse()
	if check_dash() and chain_dash_amount < chain_dash_max_amount:
		chain_dash_amount += 1
		look_at_mouse(1)
		enter()
	if check_hurt():
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
		dashing = false
		body.set_dust_particles(false)
		reset_speed()
		reset_direction()
		body.play_animation("Idle", stop_duration)
	else:
		fsm.enter_state("Idle")
