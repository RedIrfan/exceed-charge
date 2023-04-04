extends Area3D
class_name DoorArea

@onready var room : Room = get_parent()
@onready var animation : AnimationPlayer = $WallCrystal/AnimationPlayer
@onready var static_body : StaticBody3D = $WallCrystal/StaticBody3D

@export var door_direction : Room.DIRECTIONS
@export var active : bool = false : set = set_active


func _ready():
	self.connect("body_entered", _on_body_entered)
	set_active(false)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().enter_neighbour(self.name)


func set_active(new_active:bool):
	var old_active = active
	
	active = new_active
	monitoring =  active 
	
	if old_active != new_active:
		if active:	
			animation.play_backwards("Close")
		else:
			animation.play("Close")
	
	static_body.set_collision_layer_value(1, ! active)
	
	if active == false and is_connected("body_entered", _on_body_entered):
		disconnect("body_entered", _on_body_entered)
	elif is_connected("body_entered", _on_body_entered) == false:
		connect("body_entered", _on_body_entered)
