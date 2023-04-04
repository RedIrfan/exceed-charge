class_name ScanArea
extends Area3D

signal interact_list_changed

enum CHECK_OPTIONS{
	AREA,
	BODY
}

@export var check_option : CHECK_OPTIONS
@export var body : Character

var interact_list: Array


func _ready():
	match check_option:
		CHECK_OPTIONS.AREA:
			self.connect("area_entered", _on_area_entered)
			self.connect("area_exited", _on_area_exited)
		CHECK_OPTIONS.BODY:
			self.connect("body_entered", _on_area_entered)
			self.connect("body_exited", _on_area_exited)


func check_area(area):
	if area is Interactable:
		return true
	return false


func _on_area_entered(area):
	if check_area(area):
		interact_list.append(area)
		emit_signal("interact_list_changed")


func _on_area_exited(area):
	if area in interact_list:
		interact_list.erase(area)
		emit_signal("interact_list_changed")


func interact():
	var interactable = get_interactable()
	if interactable != null:
		get_interactable().interact(body)


func get_interactable():
	var interactable = null
	if interact_list.size() == 1:
		interactable = interact_list[0]
	else:
		var nearest_interactable = null
		var nearest_interactable_distance = 0
		for object in interact_list:
			if nearest_interactable == null:
				nearest_interactable = object
				nearest_interactable_distance = body.global_transform.origin.distance_to(object.global_transform.origin)
			else:
				var object_distance_to_player = body.global_transform.origin.distance_to(object.global_transform.origin)
				if object_distance_to_player < nearest_interactable_distance:
					nearest_interactable = object
					nearest_interactable_distance = object_distance_to_player
		
		interactable = nearest_interactable
	return interactable
