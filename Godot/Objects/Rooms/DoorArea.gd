extends Area3D

@onready var room : Room = get_parent()

@export var door_direction : Room.DIRECTIONS


func _ready():
	self.connect("body_entered", _on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		pass
