extends EffectAnimation

@onready var card_texture : TextureRect = $CanvasLayer/CardSprite/TextureRect


func on_spawn(params={}):
	var card_data : CardData = params["card"]
	card_texture.set_texture(card_data.get_card_image())
	
	super.on_spawn(params)
