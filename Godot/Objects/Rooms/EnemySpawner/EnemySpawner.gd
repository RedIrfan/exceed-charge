extends Node3D
class_name EnemySpawner

@export var drop_data : EnemyDropData


func spawn(receiver):
	var enemy = drop_data.drop(self.global_position, receiver)
	enemy.connect("dead", get_parent()._on_enemy_dead)
