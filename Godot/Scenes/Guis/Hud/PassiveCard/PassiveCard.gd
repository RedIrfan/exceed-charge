extends TextureRect

@onready var pip_rect : TextureRect = $Pip
@onready var amount_label : Label = $Amount

var card_suit : CardData.SUITS
var card_value : CardData.VALUES
var amount : int = 0


func set_card_data(suit, value, new_amount):
	card_suit = suit
	card_value = value
	set_amount(new_amount)
	
	update_card_graphics()


func set_amount(new_amount):
	amount = new_amount
	
	if amount <= 0:
		self.visible = false
	else:
		self.visible = true
		amount_label.set_text(str(amount))


func update_card_graphics():
	var pip_texture = load("res://Assets/Hud/Cards/PassiveCards/" + CardData.suit_to_string(card_suit) + "/" + CardData.value_to_string(card_value) + ".png")
	pip_rect.set_texture(pip_texture)

