extends EffectAttack

@export var enemy_spawn_data : EnemyDropData

@onready var spawn_enemy1_position : Marker3D = $SpawnEnemy1
@onready var spawn_enemy2_position : Marker3D = $SpawnEnemy2

var enemy_amount : int = 2


func on_spawn(params={}):
	enemy_spawn_data.drop(spawn_enemy1_position.global_position, Global.root_scene().player)[1].connect("dead", _on_dead)
	enemy_spawn_data.drop(spawn_enemy2_position.global_position, Global.root_scene().player)[1].connect("dead", _on_dead)
	
	super.on_spawn(params)


func _on_dead():
	enemy_amount -= 1
	
	if enemy_amount <= 0:
		_destroy()
