extends Panel

@onready var activating_timer : Timer = $ActivateTimer
@onready var end_activating : Panel = $EndDirection

var deck : Control = get_parent()

var held : bool = false
var activating : bool = false
var mouse_on_start_activate : bool = false
var mouse_on_start_before_end : bool = false
var mouse_on_end_activate : bool = false


func _ready():
	deck = get_parent()
	activating_timer.connect("timeout", _on_activating_timeout)


func hold():
	held = true
	activating = false
	mouse_on_start_activate = false
	mouse_on_start_before_end = false
	mouse_on_end_activate = false
	
	if self.is_connected("mouse_entered", _entered_activate_area) == false:
		self.connect("mouse_entered", _entered_activate_area)
		self.connect("mouse_exited", _exited_activate_area)
	
	if end_activating.is_connected("mouse_entered", _entered_end_activate) == false:
		end_activating.connect("mouse_entered", _entered_end_activate)
		end_activating.connect("mouse_exited", _exited_end_activate)



func release():
	if held == true:
		held = false
		self.disconnect("mouse_entered", _entered_activate_area)
		self.disconnect("mouse_exited", _exited_activate_area)
		
		end_activating.disconnect("mouse_entered", _entered_end_activate)
		end_activating.disconnect("mouse_exited", _exited_end_activate)


func _entered_activate_area():
	activating = false
	if mouse_on_end_activate == false:
		mouse_on_start_activate = true


func _exited_activate_area():
	await get_tree().create_timer(0.1).timeout
	
	mouse_on_start_activate = false


func _entered_end_activate():
	mouse_on_end_activate = true
	if mouse_on_start_activate:
		mouse_on_start_before_end = true


func _exited_end_activate():
	if mouse_on_start_before_end:
		activating = true
		activating_timer.start(0.1)
	
	await get_tree().create_timer(0.1).timeout
	mouse_on_end_activate = false


func _on_activating_timeout():
	if activating:
		deck.use_card()
