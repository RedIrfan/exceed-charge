extends Control
class_name GuiMaster

const CONFIRMATION_MENU : PackedScene = preload('res://Scenes/Menus/PopupUI/ConfirmationMenu/ConfirmationMenu.tscn')

@export var starting_gui : Gui

var player : Character

var gui_list : Dictionary = {}
var current_gui : Gui


func _ready():
	for child in get_children():
		if child is Gui:
			gui_list[child.name.to_lower()] = child
	
	await Signal(Global.root_scene(), "ready")
	
	player = Global.root_scene().player
	enter_gui(starting_gui.name)
	
	player.connect("dead", _on_player_dead)


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
	
	if Input.is_action_just_pressed("ui_cancel"):
		gui_list['pausemenu'].enter()


func _physics_process(delta):
	if current_gui:
		current_gui.physics_process(delta)


func _on_player_dead():
	Global.pause(true)
	
	var confirmation_menu : ConfirmationMenu = CONFIRMATION_MENU.instantiate().spawn(self)
	
	await confirmation_menu.set_question("Game Over", ConfirmationMenu.ANSWERS.CONFIRMED, "Restart", "Main Menu").answered
	
	if confirmation_menu.answer == ConfirmationMenu.ANSWERS.CONFIRMED:
		Global.stage_master().restart(true)
	else:
		Global.stage_master().exit_main_menu()
	
	Global.pause(false)
