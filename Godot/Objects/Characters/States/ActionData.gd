extends Node
class_name ActionData

signal action_played

## Action duration
@export var duration : float = 0

@export_group("Animation")
@export var animation_name : String

@export_group("Attack")
@export var hitbox : Hitbox
@export var damage : float = 0
@export var damage_type : Global.DAMAGES
@export var force_damage : bool = false
@export var can_combo : bool = false

@export_subgroup("Projectile", "projectile_")
@export var projectile_scene : PackedScene
@export var projectile_spawn_position : Node3D

@export_group("Transform")
@export var direction : Vector2
@export var speed : float = 0
@export var process_direction : bool = false

@export_group("Effects", "effect_")
@export var effect_node : GPUParticles3D

@export_subgroup("External", "effect_")
@export var effect_scene : PackedScene
@export var effect_spawn_position : Node3D
@export var effect_parameters : Dictionary

@export_subgroup("External Signal")
@export var external_signal_name : String
@export var connect_node : Node
@export var connect_method_name : String

@export_group("Physics", "physics_")
@export var physics_collision_mask_value : int = 0
@export var physics_collision_mask_mode : bool = false

@export_group("Sound")
@export var sound_files : Array[AudioStream]

var divided_to_whole_duration : float = 0


func get_action_data(_body) -> ActionData:
	return self
