extends Effect

const SHIELD_MESH = preload('res://Objects/Effects/ShieldCircle/ShieldMesh.tscn')
const AGILITY_SHIELD_MESH = preload("res://Objects/Effects/ShieldCircle/AgilityShieldMesh.tscn")

@export var speed : float = 1
@export var defense_shield_distance : Vector3 = Vector3(0, 1.3, 1.5)
@export var agility_shield_distance : Vector3 = Vector3(0, 1.3, 1)

@onready var pivot : Node3D = $Pivot

var player : Character
var defense_shields : Dictionary
var agility_shields : Dictionary


func _ready():
	await Global.root_scene().ready
	
	player = Global.root_scene().player
	
	player.status.connect("extra_attributes_changed", _on_extra_attributes_changed)


func _physics_process(delta):
	
	if player:
		self.global_position = player.global_position
		pivot.rotate(Vector3.UP, speed * delta)


func _on_extra_attributes_changed():
	var shield_amount = player.get_extra_attribute('defense_shield_amount')
	var agility_shield_amount = player.get_extra_attribute('agility_shield_amount')
	
	defense_shields = spawn_shields(shield_amount, SHIELD_MESH, defense_shields, "Defense", defense_shield_distance)
	agility_shields = spawn_shields(agility_shield_amount, AGILITY_SHIELD_MESH, agility_shields, "Agility", agility_shield_distance)


func spawn_shields(amount:int, mesh:PackedScene, shield_collection:Dictionary, object_name_prefix:String, shield_distance:Vector3):
	if amount > 0:
		var rotation_interval = 360.0 / amount
		
		for index in amount:
			var object : MeshInstance3D
			var object_name = object_name_prefix + str(index)
			var object_rotation = deg_to_rad(rotation_interval * index )
			var object_position = shield_distance.rotated(Vector3.UP, object_rotation )
			
			if shield_collection.has(object_name):
				object = shield_collection[object_name]
			else:
				object = mesh.instantiate()
				pivot.add_child(object)
				
				shield_collection[object_name] = object
			
			object.name = object_name
			object.rotation.y = object_rotation
			object.position = object_position
		
	return shield_collection
