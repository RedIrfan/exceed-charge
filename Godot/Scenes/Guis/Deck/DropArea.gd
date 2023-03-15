extends Panel

@onready var deck : Control = get_parent()

var mouse_is_on_area : bool = false


func hold():
	mouse_is_on_area = false
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


func release():
	if mouse_is_on_area:
		mouse_is_on_area = false
		deck.drop_card()
	
	if self.is_connected("mouse_entered", _on_mouse_entered):
		self.disconnect("mouse_entered", _on_mouse_entered)
		self.disconnect("mouse_exited", _on_mouse_exited)


func _on_mouse_entered():
	mouse_is_on_area = true


func _on_mouse_exited():
	mouse_is_on_area = false
