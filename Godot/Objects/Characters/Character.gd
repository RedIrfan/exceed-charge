extends CharacterBody3D
class_name Character

signal dead
signal health_changed(new_health)

const DAMAGE_LABEL : PackedScene = preload("res://Objects/Effects/DamageLabel/DamageLabel.tscn")
const HIT_PARTICLES : PackedScene = preload('res://Objects/Effects/HitParticles/HitParticles.tscn')

@onready var pivot : Node3D = $Pivot
@onready var animation_tree : AnimationTree = $Pivot/AnimationTree
@onready var animation_timer : Timer = $Pivot/AnimationTimer

@export var HEALTH : int = 100
@export var SPEED : float = 4
@export_range(0, 1, 0.05) var rotation_speed : float = 0.5

@export_group("Effects")
@export var hit_colour : Color = Color(1,0,0)

var maximum_health : float = HEALTH
var health : float = HEALTH : set = set_health
var speed  : float = SPEED

var direction = Vector2.ZERO
var hurt_data : Hurtdata = null


func _ready():
	maximum_health = HEALTH
	health = HEALTH
	speed = SPEED


func _physics_process(delta):
	_move(delta)


func _move(delta):
	velocity.y -= Global.GRAVITY * delta
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	move_and_slide()


func _on_dead():
	emit_signal("dead")
	process_dead()


func process_damage(damage:float):
	var hit_particles = HIT_PARTICLES.instantiate()
	hit_particles.spawn(self.global_position, [self.global_rotation, hit_colour])
	
	var label = DAMAGE_LABEL.instantiate()
	label.spawn(self.global_position, [damage])
	
	set_health(health-damage)


func process_dead():
	pass


func play_animation(animation_name:String, animation_duration:float=0, force_travel:bool=false):
	if animation_tree.tree_root.has_node(animation_name):
		if force_travel == false:
			animation_tree.get('parameters/playback').travel(animation_name)
		else:
			animation_tree.get('parameters/playback').start(animation_name)
		if animation_duration != 0:
			start_animation_timer(animation_duration)
	else:
		printerr("CHARACTER HAS NO ANIMATION NAMED " + animation_name + " !")


func start_animation_timer(animation_duration:float=0):
	animation_timer.start(animation_duration)


func connect_to_animation_timer(target_callable:Callable):
	if animation_timer.timeout.is_connected(target_callable) == false:
		animation_timer.timeout.connect(target_callable)


func disconnect_from_animation_timer(target_callable:Callable):
	if animation_timer.timeout.is_connected(target_callable):
		animation_timer.timeout.disconnect(target_callable)


func set_hurtdata(new_hurt_data : Hurtdata):
	hurt_data = new_hurt_data


func set_health(new_health:float):
	health = clamp(new_health, 0, maximum_health)
	emit_signal("health_changed", health)


func set_move_speed(new_speed:float):
	speed = new_speed


func set_move_attack_speed(new_speed:float):
	speed = new_speed
