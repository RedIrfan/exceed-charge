extends StatePlayer

@onready var dash_timer :Timer = $DashTimer

@export var dash_speed : int = 10
@export var dash_duration : float = 0.1667
@export var stop_duration : float = 0.25
@export var dash_cooldown : float = 0.05

var dash_direction : Vector2 = Vector2.ZERO


func enter(_msg=[]):
	body.connect_to_animation_timer(_on_animation_timeout)
	body.speed = dash_speed
	
	dash_direction = get_direction()
	_play_dash_animation()


func exit():
	body.disconnect_from_animation_timer(_on_animation_timeout)
	
	reset_speed()
	reset_direction()
	dash_timer.start(dash_cooldown)


func physics_process(_delta):
#	look_at_mouse()
	if check_hurt():
		fsm.enter_state("Hurt")
	if body.speed == dash_speed:
		apply_direction(dash_direction)


func _play_dash_animation():
	var animation_name = "Dash"
	
	animation_name += get_relative_direction_name(dash_direction)
	
	if animation_name != "Dash":
		body.play_animation(animation_name, dash_duration)


func _on_animation_timeout():
	if body.speed == dash_speed:
		reset_speed()
		reset_direction()
		body.play_animation("Idle", stop_duration)
	else:
		fsm.enter_state("Idle")
