extends Area3D

signal pickup_list_changed

@export var body : Character

var pickup_list: Array


func _ready():
	self.connect("area_entered", _on_area_entered)
	self.connect("area_exited", _on_area_exited)


func _on_area_entered(area):
	if area is Pickupable:
		pickup_list.append(area)
		emit_signal("pickup_list_changed")


func _on_area_exited(area):
	if area in pickup_list:
		pickup_list.erase(area)
		emit_signal("pickup_list_changed")


func pickup():
	var pickupable = get_pickupable()
	if pickupable != null:
		get_pickupable().pickup(body)


func get_pickupable() -> Pickupable:
	var pickupable = null
	if pickup_list.size() == 1:
		pickupable = pickup_list[0]
	else:
		var nearest_pickupable = null
		var nearest_pickupable_distance = 0
		for object in pickup_list:
			if nearest_pickupable == null:
				nearest_pickupable = object
				nearest_pickupable_distance = body.global_transform.origin.distance_to(object.global_transform.origin)
			else:
				var object_distance_to_player = body.global_transform.origin.distance_to(object.global_transform.origin)
				if object_distance_to_player < nearest_pickupable_distance:
					nearest_pickupable = object
					nearest_pickupable_distance = object_distance_to_player
		
		pickupable = nearest_pickupable
	return pickupable
