extends StateCharacter
class_name StateCharacterDead

@export var hurt_light_animation_name : String = "HurtLightDead"
@export var dead_animation_name : String = ""
@export var delay_before_process: float = 0
@export var after_death_state : State

var already_dead : bool


func enter_condition(_new_body, new_fsm, _msg=[]):
	if already_dead:
		on_dead()
		return false
	return true


func enter(msg=[]):
	if msg.size() > 0:
		if msg[0].damage_type == Global.DAMAGES.LIGHT and hurt_light_animation_name != "":
			body.play_animation(hurt_light_animation_name)
	reset_direction()
	reset_speed()
	
	if dead_animation_name != "":
		body.play_animation(dead_animation_name)
	
	if delay_before_process > 0:
		await get_tree().create_timer(delay_before_process).timeout
		on_dead()
	else:
		on_dead()


func on_dead():
	already_dead = true
	if after_death_state:
		fsm.enter_state(after_death_state.name)
	else:
		body._on_dead()
