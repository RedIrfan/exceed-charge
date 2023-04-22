extends StateCharacter
class_name StateCharacterHurt

const SOUND_HIT : AudioStreamWAV = preload("res://Assets/SFX/Game/Hit.wav")
const SOUND_DEFENDED : AudioStreamWAV = preload("res://Assets/SFX/Game/Defended.wav")

@export_category("Knockback")

@export_enum("None:-1", "Light:0", "Heavy:1", "Both:2") var unstaggerable : int = -1
@export var immovable : bool = false

@export_group("Light", "light_")
@export var light_knockback_speed : int = 4
@export var light_knockback_duration : float = 0.125

@export_subgroup("Animation", "light_")
@export var	light_animation_duration : float = 0.4167

@export_group("Heavy", "heavy_")
@export var heavy_knockback_speed : int = 5
@export var heavy_knockback_duration : float = 0.5
@export var heavy_wakeup_duration  : float = 0.5

@export_subgroup("Animation", "heavy_")
@export var heavy_animation_duration : float = 1.0
@export var heavy_animation_transition_to_idle_duration : float = 0.25

var hurt_data : Hurtdata 
var hurt_state_index : int = 0


func enter_condition(_body, _fsm, msg=[]) -> bool:
	body = _body
	hurt_data = body.hurt_data
	body.hurt_data = null
	
	if hurt_data.force_damage == false:
		var unstaggerable_true : bool = false
		if unstaggerable > -1:
			if hurt_data.damage_type == unstaggerable or unstaggerable == 2:
				unstaggerable_true = true
		
		
		if msg.has("unstaggerable") or unstaggerable_true:
			Global.play_sound(SOUND_DEFENDED, body.global_position)
			
			_process_damage()
			if _check_dead():
				return true
			else:
				return false
	return true


func enter(_msg=[]):
	Global.play_sound(SOUND_HIT, body.global_position)
	
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
	
	if _check_dead() == false or hurt_data.damage_type == Global.DAMAGES.HEAVY:
		body.play_animation("Hurt" + animation_name[hurt_data.damage_type], _get_knockback()[1], true)
	else:
		fsm.enter_state("Dead", [hurt_data])


func exit():
	hurt_state_index = 0
	body.disconnect_from_animation_timer(_on_animation_timeout)
	reset_direction()
	reset_speed()


func process(_delta):
	if body.hurt_data != null:
		if hurt_data.damage_type != Global.DAMAGES.HEAVY:
			fsm.enter_state(self.name)
		elif hurt_state_index == 0 or hurt_state_index == 3:
			fsm.enter_state(self.name)
		elif hurt_state_index == 1 or hurt_state_index == 2:
			body.hurt_data = null


func _process_damage():
	body.process_damage(hurt_data.damage)


func _check_dead() -> bool:
	if body.health <= 0:
		return true
	return false


func _get_knockback() -> Array:
	match hurt_data.damage_type:
		Global.DAMAGES.LIGHT:
			return [light_knockback_speed, light_knockback_duration, light_animation_duration-light_knockback_duration]
		Global.DAMAGES.HEAVY:
			return [heavy_knockback_speed, heavy_knockback_duration, heavy_animation_duration-heavy_knockback_duration]
	return [0,0]


func _on_animation_timeout():
	if hurt_state_index == 0:
		hurt_state_index = 1
		reset_direction()
		if _check_dead() == false:
			body.start_animation_timer(_get_knockback()[2])
		else:
			fsm.enter_state("Dead", [hurt_data])
	elif hurt_data.damage_type == Global.DAMAGES.HEAVY and hurt_state_index == 1:
		hurt_state_index = 2
		if heavy_wakeup_duration > 0:
			body.play_animation("HurtWakeup", heavy_wakeup_duration)
		else:
			_on_animation_timeout()
	elif hurt_data.damage_type == Global.DAMAGES.HEAVY and hurt_state_index == 2:
		hurt_state_index = 3
		if heavy_animation_transition_to_idle_duration > 0:
			body.play_animation("Idle", heavy_animation_transition_to_idle_duration)
		else:
			_on_animation_timeout()
	else:
		fsm.enter_state("Idle")
