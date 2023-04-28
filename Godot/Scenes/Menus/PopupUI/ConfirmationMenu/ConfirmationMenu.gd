class_name ConfirmationMenu
extends PopupUI

signal answered(final_answer)

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
var focus_on : ANSWERS
var erase_after_answering : bool = false


func spawn(spawner:Node, _erase_after_answering:bool=true):
	spawner.add_child(self)
	erase_after_answering = _erase_after_answering
	
	return self


func set_focus_on(focus:ANSWERS):
	focus_on = focus
	match focus_on:
		ANSWERS.CONFIRMED:
			confirm_button.grab_focus()
		ANSWERS.CANCELED:
			cancel_button.grab_focus()


func set_question(new_question:String, new_focus_on:ANSWERS=ANSWERS.CANCELED, confirm_text:String="Confirm", cancel_text:String="Cancel"):
	question = new_question
	question_label.set_text(question)
	
	confirm_button.set_text(confirm_text)
	cancel_button.set_text(cancel_text)
	
	answer = ANSWERS.NONE
	
	enter()
	set_focus_on(new_focus_on)
	
	return self


func set_answer(new_answer:ANSWERS):
	answer = new_answer
	exit()


func _on_confirm_button_pressed():
	set_answer(ANSWERS.CONFIRMED)


func _on_cancel_button_pressed():
	set_answer(ANSWERS.CANCELED)


func _on_animation_player_animation_finished(_anim_name):
	if answer == ANSWERS.NONE:
		set_focus_on(focus_on)
	else:
		emit_signal("answered", answer)
		
		if erase_after_answering:
			queue_free()
