extends Control
class_name Gui

signal entered
signal exited

var gm


func _ready():
	self.visible = false


func enter():
	self.visible = true
	
	emit_signal("entered")


func exit():
	self.visible = false
	
	emit_signal("exited")


func process(_delta):
	pass


func physics_process(_delta):
	pass
