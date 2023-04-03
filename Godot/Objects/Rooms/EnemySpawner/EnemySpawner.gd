extends Node3D
class_name EnemySpawner

@export var drop_data : EnemyDropData
@export var group_spawn_condition : ChanceData = null

var room : Room

var enemy_amount : int = 1
var enemies : Array[EnemySpawner]


func _ready():
	if get_parent() is Room:
		room = get_parent()
	
	if get_child_count() > 0:
		for child in get_children():
			if child is EnemySpawner:
				enemy_amount += 1
				enemies.append(child)
				
				child.room = room


func spawn(receiver):
	var object = drop_data.drop(self.global_position, receiver)
	if object[1]:
		object[1].connect("dead", room._on_enemy_dead)
	
	if object[0] == group_spawn_condition:
		for enemy in enemies:
			enemy.spawn(receiver)
