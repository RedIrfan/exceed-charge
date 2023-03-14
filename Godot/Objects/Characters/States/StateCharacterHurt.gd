extends StateCharacter
class_name StateCharacterHurt

@export_category("Knockback")

@export var immovable : bool = false

@export_group("Light")
@export var knockback_speed_light : int = 4
@export var knockback_duration_light : float = 0.125

@export_subgroup("Animation")
@export var	animation_duration_light : float = 0.4167

@export_group("Heavy")
@export var knockback_speed_heavy : int = 5
@export var knockback_duration_heavy : float = 0.5
@export var wakeup_duration  : float = 0.5

@export_subgroup("Animation")
@export var animation_duration_heavy : float = 1.0
@export var animation_transition_to_idle_duration : float = 0.25

var hurt_data : Hurtdata 
var hurt_state_index : int = 0


func enter_condition(_body, _fsm, msg=[]) -> bool:
	body = _body
	hurt_data = body.hurt_data
	body.hurt_data = null
	
	_process_damage()
	
	if msg.has("unstaggerable"):
		return false
	return true


func enter(_msg=[]):
	body.connect_to_animation_timer(_on_animation_timeout)
	
	body.look_at(hurt_data.attack_position, Vector3.UP)
	body.rotation_degrees.x = 0
	
	var body_back_scalar = body.global_transform.basis.z
	var animation_name = ["Light", "Heavy"]
	
	_process_damage()
	Global.pause(true, Global.PAUSES.CUTSCENE)
	await get_tree().create_timer(0.05).timeout
	Global.pause(false)
	
	if immovable == false:
		body.direction = Vector2(body_back_scalar.x, body_back_scalar.z)
		body.speed = _get_knockback()[0]
	
	body.play_animation("Hurt" + animation_name[hurt_data.damage_type], _get_knockback()[1], true)


func exit():
	hurt_state_index = 0
	body.disconnect_from_animation_timer(_on_animation_timeout)
	reset_direction()
	reset_speed()


func process(_delta):
	if body.hurt_data != null:
		fsm.enter_state(self.name)


func _process_damage():
	body.health -= hurt_data.damage


func _get_knockback() -> Array:
	match hurt_data.damage_type:
		Global.DAMAGES.LIGHT:
			return [knockback_speed_light, knockback_duration_light, animation_duration_light-knockback_duration_light]
		Global.DAMAGES.HEAVY:
			return [knockback_speed_heavy, knockback_duration_heavy, animation_duration_heavy-knockback_duration_heavy]
	return [0,0]


func _on_animation_timeout():
	if hurt_state_index == 0:
		hurt_state_index = 1
		reset_direction()
		body.start_animation_timer(_get_knockback()[2])
	elif hurt_data.damage_type == Global.DAMAGES.HEAVY and hurt_state_index == 1:
		hurt_state_index = 2
		if wakeup_duration > 0:
			body.play_animation("HurtWakeup", wakeup_duration)
		else:
			_on_animation_timeout()
	elif hurt_data.damage_type == Global.DAMAGES.HEAVY and hurt_state_index == 2:
		hurt_state_index = 3
		if animation_transition_to_idle_duration > 0:
			body.play_animation("Idle", animation_transition_to_idle_duration)
		else:
			_on_animation_timeout()
	else:
		fsm.enter_state("Idle")
