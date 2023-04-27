class_name ConfirmationMenu
extends PopupUI

enum ANSWERS{
	NONE,
	CONFIRMED,
	CANCELED
}

@onready var question_label :Label = $Panel/Inside/Label

@onready var confirm_button : Button = $Panel/Inside/HBoxContainer/ConfirmButton
@onready var cancel_button : Button = $Panel/Inside/HBoxContainer/CancelButton

var question : String
var answer : ANSWERS = ANSWERS.NONE
var listener : Callable
var focus_on : ANSWERS

var listener_exists : bool = false


func set_focus_on(focus:ANSWERS):
	focus_on = focus
	match focus_on:
		ANSWERS.CONFIRMED:
			confirm_button.grab_focus()
		ANSWERS.CANCELED:
			cancel_button.grab_focus()


func set_question(new_question:String, callable=null, new_focus_on:ANSWERS=ANSWERS.CANCELED):
	question = new_question
	question_label.set_text(question)
	
	answer = ANSWERS.NONE
	
	if callable != null:
		listener_exists = true
		listener = callable
		
		self.exited.connect(callable)
	
	enter()
	set_focus_on(new_focus_on)
	await animation_player.animation_finished
	set_focus_on(new_focus_on)


func _on_confirm_button_pressed():
	set_answer(ANSWERS.CONFIRMED)


func _on_cancel_button_pressed():
	set_answer(ANSWERS.CANCELED)


func set_answer(new_answer:ANSWERS):
	answer = new_answer
	exit()
	
	await self.exited
	
	if listener_exists:
		listener_exists = false
		self.exited.disconnect(listener)
