extends CharacterBody3D
class_name Character

signal dead
signal health_changed(new_health)

@onready var animation_tree : AnimationTree = $Pivot/AnimationTree
@onready var animation_timer : Timer = $Pivot/AnimationTimer

@export var HEALTH : int = 100
@export var SPEED : int = 4
@export var rotation_speed : float = 0.5

var health = HEALTH : set = set_health
var speed = SPEED

var direction = Vector2.ZERO
var hurt_data : Hurtdata = null


func _ready():
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
	animation_timer.timeout.connect(target_callable)


func disconnect_from_animation_timer(target_callable:Callable):
	if animation_timer.timeout.is_connected(target_callable):
		animation_timer.timeout.disconnect(target_callable)

func set_hurtdata(new_hurt_data : Hurtdata):
	hurt_data = new_hurt_data


func set_health(new_health:int):
	health = new_health
	emit_signal("health_changed", health)
