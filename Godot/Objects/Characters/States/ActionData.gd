extends Node
class_name ActionData

## Action duration
@export var duration : float = 0

@export_group("Animation")
@export var animation_name : String

@export_group("Attack")
@export var hitbox : Hitbox
@export var damage : int = 0
@export var damage_type : Global.DAMAGES
@export var can_combo : bool = false

@export_group("Transform")
@export var direction : Vector2
@export var speed : float = 0
