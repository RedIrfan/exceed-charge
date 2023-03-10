extends Control
class_name GuiMaster

@export var starting_gui : Gui

var player : Character

var gui_list : Dictionary = {}
var current_gui : Gui


func _ready():
	for child in get_children():
		if child is Gui:
			gui_list[child.name.to_lower()] = child
	
	await Signal(Global.root_scene(), "ready")
	
	enter_gui(starting_gui.name)
	player = Global.root_scene().player


func enter_gui(gui_name:String):
	gui_name = gui_name.to_lower()
	if gui_list.has(gui_name):
		if current_gui:
			current_gui.exit()
			await Signal(current_gui, "exited")
		current_gui = gui_list[gui_name]
		current_gui.gm = self
		current_gui.player = player
		current_gui.enter()


func _process(delta):
	if current_gui:
		current_gui.process(delta)


func _physics_process(delta):
	if current_gui:
		current_gui.physics_process(delta)
