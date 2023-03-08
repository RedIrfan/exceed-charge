extends Node
class_name ActionData

@export_subgroup("Animation")
@export var animation_name : String
@export var animation_duration : float = 0

@export_subgroup("Attack")
@export var hitbox : Hitbox
@export var damage : int = 0
@export var damage_type : Global.DAMAGES

@export_subgroup("Transform")
@export var direction : Vector2
@export var speed : float = 0
