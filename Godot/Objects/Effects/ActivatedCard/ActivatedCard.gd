extends Effect

const PARTICLES = preload("res://Objects/Effects/ActivatedCard/Particles/Particles.tscn")
const SOUND_ACTIVATE_CARD = preload('res://Assets/SFX/Deck/ActivateCard.wav')

var middle_position : Vector3 = Vector3(-1, 1, -1.2)
var end_position : Vector3 = Vector3(0, 1.3, 0)

var player : Character

var direction : Vector3


func on_spawn(_parameters={}):
	player = Global.root_scene().player
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	var tween_duration = (duration-0.01)/2
	
	var start_position = Global.root_scene().camera.camera3d.position
	
	middle_position.y = start_position.y/2
	
	tween.tween_method(change_direction, Vector3.ZERO, middle_position, tween_duration)
	tween.tween_method(change_direction, middle_position, end_position, tween_duration)


func change_direction(to_position:Vector3):
	to_position = player.global_position + to_position.rotated(Vector3.UP, player.rotation.y)
	direction = (to_position - self.global_position).normalized()
	

func _physics_process(delta):
	if direction != Vector3.ZERO:
		move_to(delta)


func move_to(delta):
	if direction != Vector3.ZERO:
		look_at(global_position + (direction*2), Vector3.UP)
	
	var speed = (self.global_position.distance_to(player.global_position) / kill_timer.time_left)
	direction = direction * speed
	global_position += direction * delta


func _on_kill_timeout():
	var particles = PARTICLES.instantiate()
	particles.spawn(player.global_position, {"target" : player, "bonus_position" : end_position})
	
	var soundfx = SoundFx.new()
	soundfx.spawn(Vector3.ZERO, {"audio" : SOUND_ACTIVATE_CARD})
	
	_destroy()
