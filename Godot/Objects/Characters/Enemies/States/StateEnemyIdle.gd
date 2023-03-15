extends StateEnemy

@export var idle_duration : float = 2

@onready var idle_timer : Timer = $IdleTimer


func enter(_msg=[]):
	if fsm.previous_state != null:
		if fsm.previous_state.name != "Hurt":
			idle_timer.start(idle_duration)
	
	body.play_animation("Idle")


func process(_delta):
	look_at_target()
	if idle_timer.is_stopped():
		if check_attack():
			fsm.enter_state("Attack")
		else:
			fsm.enter_state("Pursue")
	
	if check_hurt():
		fsm.enter_state("Hurt")
