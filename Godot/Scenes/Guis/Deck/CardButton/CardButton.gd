extends TextureButton

signal held(card)

@onready var selected_outline: Panel = $SelectedOutline

var card_index_in_deck : int = 0


func _ready():
	selected_outline.visible = false
	
	self.connect("mouse_entered", _selected)
	self.connect("mouse_exited", _not_selected)
	
	self.connect("pressed", _on_pressed)


func _selected():
	selected_outline.visible = true


func _not_selected():
	selected_outline.visible = false


func _on_pressed():
	emit_signal("held", self)
