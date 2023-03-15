extends Pickupable
class_name CardPickupable

@onready var sprite : Sprite3D = $Pivot/Sprite3D

var card_data : CardData


func _on_spawn(parameters=[]):
	card_data = parameters[0]
	
	sprite.texture = card_data.get_card_image()


func _on_pickup(body):
	if body.deck.add_card(card_data):
		_destroy()
