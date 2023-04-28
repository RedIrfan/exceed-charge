extends Control

enum CHARACTERS{
	STAR,
}


@onready var button_containers : Container = $MarginContainer/VSplitContainer/MarginContainer/VBoxContainer
@onready var start_button : Button = $MarginContainer/VSplitContainer/MarginContainer/VBoxContainer/StartButton
@onready var option_button : Button = $MarginContainer/VSplitContainer/MarginContainer/VBoxContainer/OptionButton
@onready var exit_button : Button  =$MarginContainer/VSplitContainer/MarginContainer/VBoxContainer/ExitButton

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var star_decker_animation : AnimationPlayer = $SubViewportContainer/SubViewport/Camera3D/Players/Player/AnimationPlayer

@onready var option_menu : PopupUI = $OptionMenu
@onready var confirmation_menu : ConfirmationMenu = $ConfirmationMenu

var in_home : bool = true


func _ready():
	start_button.grab_focus()
	change_character(CHARACTERS.STAR)


func _process(delta):
	if in_home:
		if Input.is_action_just_pressed("move_left"):
			change_character(CHARACTERS.STAR)
		if Input.is_action_just_pressed("move_right"):
			change_character(CHARACTERS.STAR)


func change_character(character:CHARACTERS):
	animation_player.stop()
	animation_player.play("ChangeCharacter")
	star_decker_animation.stop()
	star_decker_animation.play("Idle")
	star_decker_animation.play("DeckOutsideIdle", 0.3)


func _on_start_button_pressed():
	star_decker_animation.stop()
	star_decker_animation.play("DeckOutsideScan")
	
	await star_decker_animation.animation_finished
	
	Global.change_scene("res://Scenes/Stages/StageMaster.tscn")


func _on_option_button_pressed():
	in_home = false
	
	option_menu.enter()
	await option_menu.exited
	
	option_button.grab_focus()
	
	in_home = true


func _on_exit_button_pressed():
	in_home = false
	
	confirmation_menu.set_question("Exit?")
	await confirmation_menu.exited
	
	if confirmation_menu.answer == ConfirmationMenu.ANSWERS.CONFIRMED:
		get_tree().quit()
	
	exit_button.grab_focus()
	in_home = true



