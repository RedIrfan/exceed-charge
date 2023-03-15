extends Pickupable
class_name CardPickupable

@onready var sprite : Sprite3D = $Pivot/Sprite3D

@export var card_data : CardData


func _ready():
	if card_data:
		_on_spawn([card_data])


func _on_spawn(parameters=[]):
	card_data = parameters[0]
	
	sprite.texture = card_data.get_card_image()


func _on_pickup(body):
	if body.deck.add_card(card_data):
		_destroy()
