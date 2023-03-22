extends CardData
class_name ElementCardData

@export var element : StatusData.ELEMENTS


func element_to_string() -> String:
	var elements_name = ["None", "Fire", "Wind", "Water", "Ground"]
	
	return elements_name[element]


func get_card_image() -> Texture:
	if card_image == null:
		var img_path = "res://Assets/Cards/" + suit_to_string() + "/" + element_to_string() + ".png"
		
		card_image = load(img_path)
	return card_image


func process_card(body:Character) -> void:
	var status : StatusData = body.status
	status.element = element
	
	unique_process_card(body)
