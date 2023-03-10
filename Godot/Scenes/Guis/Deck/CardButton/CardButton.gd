extends TextureButton

@onready var selected_outline: Panel = $SelectedOutline


func _ready():
	selected_outline.visible = false
	
	self.connect("mouse_entered", _selected)
	self.connect("mouse_exited", _not_selected)


func _selected():
	selected_outline.visible = true


func _not_selected():
	selected_outline.visible = false
