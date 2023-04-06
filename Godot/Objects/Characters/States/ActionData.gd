extends Node
class_name ActionData

## Action duration
@export var duration : float = 0

@export_group("Animation")
@export var animation_name : String

@export_group("Attack")
@export var hitbox : Hitbox
@export var damage : float = 0
@export var damage_type : Global.DAMAGES
@export var can_combo : bool = false

@export_subgroup("Projectile", "projectile_")
@export var projectile_scene : PackedScene
@export var projectile_spawn_position : Node3D

@export_group("Transform")
@export var direction : Vector2
@export var speed : float = 0

@export_group("Effects", "effect_")
@export var effect_node : GPUParticles3D
@export_subgroup("External", "effect_")
@export var effect_scene : PackedScene
@export var effect_spawn_position : Node3D
@export var effect_parameters : Dictionary

var divided_to_whole_duration : float = 0
